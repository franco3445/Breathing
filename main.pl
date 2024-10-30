#!/usr/bin/env perl
use strict;
use warnings;
use Tk;
use Tk::ProgressBar;

my $updatePercentage = 0;
my $colorOptions = [0, 'red', 20, 'orange' , 40, 'yellow', 60, 'green', 80, 'blue'];

my $mainWindow = MainWindow->new;

my $screenHeight = $mainWindow->screenheight - 150;
my $screenWidth = $mainWindow->screenwidth;
my $windowGeometry = "x50+0+$screenHeight";

$mainWindow->geometry($screenWidth . $windowGeometry);

$mainWindow->Label(-text => 'Focus on your breathing...')->pack;

$mainWindow->ProgressBar(
    -blocks   => 100,
    -colors   => $colorOptions,
    -from     => 1,
    -gap      => 0,
    -length   => $screenWidth,
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
    my $isIncrementing = 1;
    my $pause = 1;
    my $stepSpeed = 0.01;

    while ($isIncrementing == 1){
        for (1..100) {
            $updatePercentage += $step;
            $mainWindow->update;
            select(undef, undef, undef, $stepSpeed);
        }
        sleep($pause);
        $isIncrementing = 0;
    }
    &breath($step * -1);
}
