using Godot;
using System;
using System.Collections.Generic;

/// <summary>
/// Singleton class that holds the current Time delta
/// </summary>
[GlobalClass]
public partial class Time : Node {

    public static Time Instance { get; set; }

    private static double _delta;
    public static double Delta {
        get => _delta;
    }

    private static double _physicsDelta;
    public static float PhysicsDelta{
        get => ((float)_physicsDelta);
    }

    public override void _Process(double delta) {
        base._Process(delta);
        _delta = delta;
    }

    public override void _PhysicsProcess(double delta) {
        base._PhysicsProcess(delta);
        _physicsDelta = delta;
    }
}
