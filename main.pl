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
    -from     => 0,
    -gap      => 0,
    -to       => 100,
    -length   => $screenWidth,
    -variable => \$updatePercentage,
)->pack;

$mainWindow->Button(
    -text    => 'Quit',
    -command => sub { exit },
)->pack;

$mainWindow->after(1000, (\&breath(1)));

MainLoop;

sub breath {
    my $step = shift;
    my $direction = 'up';
    while ($direction eq 'up'){
        for (1..100) {
            $updatePercentage += $step;
            $mainWindow->update;
            select(undef, undef, undef, 0.01);
        }
        select(undef, undef, undef, 0.3);
        $direction = 'down';
    }
    &breath($step * -1);
}
