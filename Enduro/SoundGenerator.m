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

#ifndef min
#define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif

#define OCTAVE 12
#define NOTEMAX 20

typedef unsigned note_t;

typedef struct{
    note_t notes[NOTEMAX];
    unsigned size;
    unsigned channels;
    char name[5];
} chord_t;


@interface Chord : NSObject
@property chord_t chord;
-(id) initWithChord: (chord_t) c;
@end
@implementation Chord
@synthesize chord;

-(id) initWithChord: (chord_t) c {
    self = [super init];
    if (self) self.chord = c;
    return self;
}
@end


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

char chordNames[5][5] = {
    "Maj",
    "Min",
    "Dom7",
    "Maj7",
    "Min7"
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
@property (strong) NSMutableDictionary *chords;
@property (strong) NSLock *chords_lock;
@end

@implementation SoundGenerator
@synthesize dataSource;
@synthesize appDelegate = _appDelegate;
@synthesize chords = _chords;
@synthesize chords_lock;

- (id) init {
    self = [super init];
    if (self) {
        self.chords = [NSMutableDictionary dictionaryWithCapacity:10];
        self.chords_lock = [[NSLock alloc] init];
    }
    return self;
}

- (AppDelegate*)appDelegate{
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication]delegate];
    return _appDelegate;
}

- (chord_t)makeChordWithVoice:(Voice)voice inversion:(Inversion)inversion number:(unsigned)number withChannels:(unsigned)channels{
    chord_t chord;
    chord.size = number;
    chord.channels = channels;
    strcpy(chord.name, chordNames[voice]);
    
    unsigned noteInChord, interval;
    for (int i=0; i<number; i++) {
        noteInChord = (i + inversion) % 4;
        interval = chords[voice][noteInChord] + ((i+inversion)/4 * OCTAVE);
        
        chord.notes[i] = KEYNOTE + interval;
    }
    
    return chord;
}

-(void)clearCache {
    while(![self.chords_lock tryLock]) usleep(1);
    [self.chords removeAllObjects];
    [self.chords_lock unlock];
}

#define HEIGHTTHRESHOLD 50
#define WIDTHTHRESHOLD 200
#define COLORTHRESHOLD 255/2.0
- (chord_t)buildChordFromPath:(UIBezierPath*)path withImage:(UIImage*)image{
    while(![self.chords_lock tryLock]) usleep(1);
    
    Chord *chord_obj;
    chord_t chord;
    
    if((chord_obj = [self.chords objectForKey:path.description])){
        chord = chord_obj.chord;
    } else {
        [self.chords_lock unlock];
        
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
        int number = min((path.bounds.size.height / HEIGHTTHRESHOLD) + 1, NOTEMAX);
        
        // determine number of channels based on width
        int channels = (path.bounds.size.width / WIDTHTHRESHOLD) + 1;
        
        chord = [self makeChordWithVoice:voice inversion:inversion number:number withChannels:channels];

        while(![self.chords_lock tryLock]) usleep(10);
        [self.chords setValue:[[Chord alloc] initWithChord: chord] forKey:path.description];
    }

    [self.chords_lock unlock];
    return chord;
}

- (void) precalculateChords: (NSArray *) blobs image: (UIImage*) image {
    dispatch_queue_t processQueue = dispatch_queue_create("Process Queue", NULL);

    for (UIBezierPath *blob in blobs) {
        dispatch_async(processQueue, ^{
            [self buildChordFromPath:blob withImage:image];
        });
    }
    dispatch_release(processQueue);
}

- (void)playChord:(chord_t)chord withVolume:(unsigned)volume{
    for (int j=0; j<chord.channels; j++) {
        int channel = [[self.dataSource.channels objectAtIndex:j] intValue];
        self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0xC0 + j, channel, 0x00); // sets the instrument
        for (int i=0;i<chord.size;i++) {
            note_t note = chord.notes[i];
            self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90 + j, note, volume);  
        }
    }
}

- (NSString*)playSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image{
    chord_t chord = [self buildChordFromPath:path withImage:image];
    [self playChord:chord withVolume:0x7f];
    return [NSString stringWithCString:chord.name encoding:NSASCIIStringEncoding];
}

- (NSString*)stopSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image{
    chord_t chord = [self buildChordFromPath:path withImage:image];
    
    [self playChord:chord withVolume:0x00];
    return [NSString stringWithCString:chord.name encoding:NSASCIIStringEncoding];
}

@end
;