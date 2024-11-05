#!/usr/bin/env perl
use strict;
use warnings;
use Tk;
use Tk::ProgressBar;
use Tk::Table;

my $LABEL = {
    default => 'Click Start to begin',
    exhale  => 'Exhale',
    inhale  => 'Inhale',
};

my $BUTTON = {
    exit  => 'Exit App',
    pause => 'Pause',
    start => 'Start',
};

my $COLOR = {
    blue   => 'blue',
    green  => 'green',
    orange => 'orange',
    red    => 'red',
    yellow => 'yellow',
};

my $PROGRESS_BAR_COLORS = [0, $COLOR->{red}, 20, $COLOR->{orange}, 40, $COLOR->{yellow}, 60, $COLOR->{green}, 80, $COLOR->{blue}];

my $isBreathing = 0;
my $labelText = $LABEL->{default};
my $progressPercentage = 0;
my $progressBarDirection = 1;

my $mainWindow = MainWindow->new;

my $xCoordinate = 0;
my $yCoordinate = $mainWindow->screenheight * .85;
my $windowWidth = $mainWindow->screenwidth;
my $windowHeight = 100;
my $windowSize = $windowWidth . 'x' . $windowHeight;
my $windowCoordinates = "$xCoordinate+$yCoordinate";

my $windowGeometry = "$windowSize+$windowCoordinates";

$mainWindow->geometry($windowGeometry);

$mainWindow->Label(-textvariable => \$labelText)->pack;

$mainWindow->ProgressBar(
    -blocks   => 100,
    -colors   => $PROGRESS_BAR_COLORS,
    -from     => 1,
    -gap      => 0,
    -length   => $windowWidth,
    -to       => 100,
    -variable => \$progressPercentage,
)->pack;

my $table = $mainWindow->Table(
    -columns    => 3,
    -rows       => 2,
    -scrollbars => '',
)->pack;

my $startButton = $table->Button(
    -command => sub { $isBreathing = 1 },
    -text    => $BUTTON->{start},
)->pack;

my $pauseButton = $table->Button(
    -command => sub { $isBreathing = 0 },
    -text    => $BUTTON->{pause},
)->pack;

my $exitButton = $table->Button(
    -command => sub { $mainWindow->destroy(); },
    -text    => $BUTTON->{exit},
)->pack;

$table->put(1,1, $startButton);
$table->put(1,2, $pauseButton);
$table->put(1,3, $exitButton);

$mainWindow->after(1000, (\&breath(1)));

MainLoop;

sub breath {
    my $step = shift;

    while ($isBreathing){
        $progressBarDirection
            ? inhale($step)
            : exhale($step);
    }
    &pause()
}

sub exhale {
    my $step = shift;
    $labelText = $LABEL->{exhale};
    while ($progressPercentage >= 0 && $isBreathing) {
        $progressPercentage -= $step;
        $mainWindow->update;
        select(undef, undef, undef, 0.01);
    }

    if ($isBreathing) {
        $progressBarDirection =! $progressBarDirection;
        sleep(1);
    }
}

sub inhale {
    my $step = shift;
    $labelText = $LABEL->{inhale};
    while ($progressPercentage <= 100 && $isBreathing) {
        $progressPercentage += $step;
        $mainWindow->update;
        select(undef, undef, undef, 0.01);
    }

    if ($isBreathing) {
        $progressBarDirection =! $progressBarDirection;
        sleep(1);
    }
}

sub pause {
    $labelText = $LABEL->{default};
    $isBreathing = 0;
    $mainWindow->update;
    sleep(.5);
    &breath(1);
}