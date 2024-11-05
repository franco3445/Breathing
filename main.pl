#!/usr/bin/env perl
use strict;
use warnings;
use Tk;
use Tk::ProgressBar;
use Tk::Table;

my $DEFAULT_BANNER = 'Click Start to begin';
my $PROGRESS_BAR_COLORS = [0, 'red', 20, 'orange' , 40, 'yellow', 60, 'green', 80, 'blue'];

my $breathing = 0;
my $banner = $DEFAULT_BANNER;
my $updatePercentage = 0;
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

$mainWindow->Label(-textvariable => \$banner)->pack;

$mainWindow->ProgressBar(
    -blocks   => 100,
    -colors   => $PROGRESS_BAR_COLORS,
    -from     => 1,
    -gap      => 0,
    -length   => $windowWidth,
    -to       => 100,
    -variable => \$updatePercentage,
)->pack;

my $table = $mainWindow->Table(
    -rows       => 2,
    -columns    => 3,
    -scrollbars => '',
)->pack;

my $startButton = $table->Button(
    -text    => 'Start',
    -command => sub { $breathing = 1 },
)->pack;

my $pauseButton = $table->Button(
    -text    => 'Pause',
    -command => sub { $breathing = 0 },
)->pack;

my $exitButton = $table->Button(
    -text    => 'Exit App',
    -command => sub { $mainWindow->destroy(); },
)->pack;

$table->put(1,1, $startButton);
$table->put(1,2, $pauseButton);
$table->put(1,3, $exitButton);

$mainWindow->after(1000, (\&breath(1)));

MainLoop;

sub breath {
    my $step = shift;

    while ($breathing){
        $banner = 'Focus on your breathing...';
        $progressBarDirection
            ? inhale($step)
            : exhale($step);
    }
    &pause()
}

sub exhale {
    my $step = shift;
    $banner = 'Exhale';
    while ($updatePercentage >= 0 && $breathing) {
        $updatePercentage -= $step;
        $mainWindow->update;
        select(undef, undef, undef, 0.01);
    }

    if ($breathing) {
        $progressBarDirection =! $progressBarDirection;
        sleep(1);
    }
}

sub inhale {
    my $step = shift;
    $banner = 'Inhale';
    while ($updatePercentage <= 100 && $breathing) {
        $updatePercentage += $step;
        $mainWindow->update;
        select(undef, undef, undef, 0.01);
    }

    if ($breathing) {
        $progressBarDirection =! $progressBarDirection;
        sleep(1);
    }
}

sub pause {
    $banner = $DEFAULT_BANNER;
    $breathing = 0;
    $mainWindow->update;
    sleep(.5);
    &breath(1);
}