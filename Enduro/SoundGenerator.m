//
//  SoundGenerator.m
//  Enduro
//
//  Created by Benjamin Koltai on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundGenerator.h"
#import "ImageCropper.h"
#import "AppDelegate.h"

#define OCTAVE 12

typedef unsigned note_t;

typedef struct{
    note_t notes[10];
    unsigned size;
    unsigned channels;
} chord_t;

#define KEYNOTE 48 // c3

/*
 Major      - 1, 3, 5, 8
 Minor      - 1, 3b, 5, 8
 Dom 7th    - 1, 3, 5, 7b
 Major 7th  - 1, 3, 5, 7
 Minor 7th  - 1, 3b, 5, 7b
 */

/* Notes
 Check image processor for notes about blob detection
 cache blob notes for faster responses, spawing threads to caclulate
 */

typedef enum {
    Root,
    FirstInversion,
    SecondInversion
} Inversion;

typedef enum {
    Major,
    Minor,
    DomSeventh,
    MajorSeventh,
    MinorSeventh    
} Voice;

unsigned channels[4][2] = { // {program, note offset}
    {0, 0},
    {52, OCTAVE},
    {0, 0},
    {0, 0}
}; 

note_t chords[][4] = {
    {0, 4, 7, 12}, // Major {1, 3 , 5}
    {0, 3, 7, 12}, // Minor {1, 3b, 5}
    {0, 4, 7, 10}, // dom7  {1, 3 , 5, 7b} 
    {0, 4, 7, 11}, // maj7  {1, 3 , 5, 7} 
    {0, 3, 7, 10}  // min7  {1, 3b, 5, 7b} 
};

// Height determines number of notes in chord

@interface SoundGenerator()
@property (nonatomic, strong) AppDelegate* appDelegate;
@end

@implementation SoundGenerator
@synthesize appDelegate = _appDelegate;

- (AppDelegate*)appDelegate{
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication]delegate];
    return _appDelegate;
}

- (chord_t)makeChordWithVoice:(Voice)voice inversion:(Inversion)inversion number:(unsigned)number withChannels:(unsigned)channels{
    chord_t chord;
    chord.size    = number;
    chord.channels = channels;
    
    unsigned noteInChord, interval;
    for (int i=0; i<number; i++) {
        noteInChord = (i + inversion) % 4;
        interval = chords[voice][noteInChord] + ((i+inversion)/4 * OCTAVE);
        
        chord.notes[i] = KEYNOTE + interval;
    }
    
    return chord;
}

#define HEIGHTTHRESHOLD 50
#define WIDTHTHRESHOLD 200
#define COLORTHRESHOLD 255/2.0
- (chord_t)buildChordFromPath:(UIBezierPath*)path withImage:(UIImage*)image{
    // determine inversion based on position of path in image
    Inversion inversion = Root;
    float pathCenter = path.bounds.origin.y + path.bounds.size.height/2.0;
    NSLog(@"Path.y = %f imge.height = %f", pathCenter , image.size.height * 0.3);
    if (pathCenter < image.size.height * 0.3) { // top third
        inversion = Root;
    } else if (pathCenter > image.size.height * 0.3 && pathCenter < image.size.height * 0.6){ // middle third
        inversion = FirstInversion;
    } else if (pathCenter > image.size.height * 0.6){ // bottome third
        inversion = SecondInversion;
    }
    
    // get the RGB values
    RGBAPixel mean_pixel = [ImageCropper averageColorOfPath:path inImage:image];

    // determine voice based on RGBA
    Voice voice;
    if (mean_pixel.red > COLORTHRESHOLD && mean_pixel.green > COLORTHRESHOLD && mean_pixel.blue > COLORTHRESHOLD) {
        voice = Major;
    } else if (mean_pixel.red < COLORTHRESHOLD && mean_pixel.green < COLORTHRESHOLD && mean_pixel.blue > COLORTHRESHOLD) {
        voice = Minor;
    } else if (mean_pixel.red > COLORTHRESHOLD && mean_pixel.green < COLORTHRESHOLD && mean_pixel.blue > COLORTHRESHOLD) {
        voice = DomSeventh;
    } else if (mean_pixel.red > COLORTHRESHOLD && mean_pixel.green > COLORTHRESHOLD && mean_pixel.blue < COLORTHRESHOLD) {
        voice = MajorSeventh;
    } else {
        voice = MinorSeventh;
    }
    
    // determine number of notes in chord based on height
    int number = (path.bounds.size.height / HEIGHTTHRESHOLD) + 1;

    // determine number of channels based on width
    int channels = (path.bounds.size.width / WIDTHTHRESHOLD) + 1;
    
    return [self makeChordWithVoice:voice inversion:inversion number:number withChannels:channels];
}

- (void)playChord:(chord_t)chord withVolume:(unsigned)volume{
    unsigned offset = 0;
    for (int j=0; j<chord.channels; j++) {
        self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0xC0 + j, channels[j][0], 0x00); // sets the instrument
        offset = channels[j][1];
        for (int i=0;i<chord.size;i++) {
            note_t note = chord.notes[i];
            self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90, note+offset, volume);  
        }
    }
}

- (void)playSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image{
    chord_t chord = [self buildChordFromPath:path withImage:image];

    [self playChord:chord withVolume:0x7f];
}

- (void)stopSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image{
    chord_t chord = [self buildChordFromPath:path withImage:image];
    
    [self playChord:chord withVolume:0x00];
}

@end
