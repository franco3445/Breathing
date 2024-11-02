#!/usr/bin/env perl
use strict;
use warnings;
use Tk;
use Tk::ProgressBar;

my $updatePercentage = 0;
my $colorOptions = [0, 'red', 20, 'orange' , 40, 'yellow', 60, 'green', 80, 'blue'];

my $mainWindow = MainWindow->new;

my $xCoordinate = 0;
my $yCoordinate = $mainWindow->screenheight * .85;
my $windowWidth = $mainWindow->screenwidth;
my $windowHeight = 50;
my $windowSize = $windowWidth . 'x' . $windowHeight;
my $windowCoordinates = "$xCoordinate+$yCoordinate";

my $windowGeometry = "$windowSize+$windowCoordinates";

$mainWindow->geometry($windowGeometry);

$mainWindow->Label(-text => 'Focus on your breathing...')->pack;

$mainWindow->ProgressBar(
    -blocks   => 100,
    -colors   => $colorOptions,
    -from     => 1,
    -gap      => 0,
    -length   => $windowWidth,
    -to       => 100,
    -variable => \$updatePercentage,
)->pack;

$mainWindow->Button(
    -text    => 'Exit App',
    -command => sub { exit },
)->pack;

$mainWindow->after(1000, (\&breath(1)));

MainLoop;

sub breath {
    my $step = shift;
    my $pause = 1;
    my $stepSpeed = 0.01;

    for (1..100) {
        $updatePercentage += $step;
        $mainWindow->update;
        select(undef, undef, undef, $stepSpeed);
    }

    sleep($pause);
    &breath($step * -1);
}
