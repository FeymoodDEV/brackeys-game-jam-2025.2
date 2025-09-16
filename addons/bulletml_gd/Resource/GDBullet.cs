using BulletMLLib;
using Godot;
using Godot.Collections;
using System;

[GlobalClass]
public partial class GDBullet : Resource
{

    [Export]
    public string BulletID { get; set; }

    [Export]
    public PackedScene BulletScene { get; set; }

}
