// A wall mount helper for "EMS Gateway E32 V2".
// Use it to glue the gateway to a wall and still be able to remove it easily.
// I recommend to use heat inserts and two M3 screws.
// On my first try to mount the gateway, one of the pins broke off.

// Copyright (C) 2026 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth  web.de

/* [Print] */

PrintThis = "all"; // ["all", "mount"]

/* [Sizes] */
Length = 125;
Width = 85;
Rounding = 16.5;
Thickness = 2.5;

PinDistance = 90;
PinWidth = 36;
PinOffset = 7.5;

FootHeight = 1.7;
// make it smaller than the housing
Inset = 0;

MountLength = 90;
MountWidth = 50;

// 0 disables hole generation
ScrewDiameter = 3.5;

// default is for M3
HeatInsertDiameter = 4.2;
HeatInsertHeight = 4.2;

/* [Pins] */
// Pins are not recommended, they break easily
PinUse = false;
PinDiameter = 3.3;
PinTotalHeight = 2.9;
PinHeight = 1.2;
PinMushroom = 6.5;

/* [Misc] */
// For revision text (0 turns off)
Fontsize=7;	//	[0:1:10]
// For revision text
Emboss=0.4;

/* [Hidden] */

module __Customizer_Limit__ () {}
	shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.25;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;

Epsilon = 0.01;
epsilon = Epsilon;

use <dfLibscad/Revision.scad>
use <dfLibscad/RoundCornersCube.scad>
use <dfLibscad/Screws.scad>
include <svn_rev.scad>

module Pin()
{
	h = FootHeight+PinHeight;
	cylinder(d=PinDiameter, h=h);
	f = 1.0;
	h2=PinTotalHeight-PinHeight-f;
	translate([0,0, h])
		cylinder(d1=PinDiameter, d2=PinMushroom, h=h2);
	translate([0,0, h+h2])
		cylinder(d=PinMushroom, h=f);
}

module WallMountNoHoles()
{
	translate([0,0,Thickness/2])
		RoundCornersCube([Length-2*Inset, Width-2*Inset, Thickness], r=Rounding);

	for(dist=[1,-1])
	{
		translate([dist*PinDistance/2, PinOffset, Thickness])
			if(PinUse)
				Pin();
			else
				translate([0, 0, -Thickness])
					cylinder(d=2.5*HeatInsertDiameter, h=HeatInsertHeight);
	}

	translate([0, 0, Thickness])
		WriteRevision(rev=SVN_RevisionStr, height=Emboss, fontsize=0.6*Fontsize, halign="center", valign="center", mirror=false, rot=[0,0,0], oneline=true, lib=true);
}

module WallMount()
{
	difference()
	{
		WallMountNoHoles();
		for(dist=[1,-1])
		{
			translate([dist*PinDistance/2, PinOffset,Thickness])
				if(!PinUse)
					cylinder(d=HeatInsertDiameter, h=3*Thickness, center=true);
		}

		if(ScrewDiameter>0)
		{
			for(x=[1,-1])
			{
				for(y=[1,-1])
				{
					translate([x*(MountLength/2), y*(MountWidth/2), Thickness])
					{
						ScrewHole(diameter=ScrewDiameter, dept=2*Thickness, type="Sink_SelfTab", hole_only=false, show_head=false, extra_sink=0);
					}
				}
			}
		}
		
	}
}

module print(what="all")
{
	if(what == "all")
	{
		WallMount();
	}
	if(what == "mount")
	{
		// Can be used to show several parts if they need mounting.
		// Not needed for this project.
	}
}

print(PrintThis);

