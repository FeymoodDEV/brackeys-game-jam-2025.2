using BulletMLLib;
using Godot;
using System;


[GlobalClass]
public partial class GDPattern : Resource
{

    /// <summary>
    /// ID for referencing this elsewhere<c>GDPattern</c>
    /// </summary>
    [Export]
    public string PatternID { get; private set; }

    [Export]
    public string BulletRefID { get; private set; }

    /// <summary>
    /// Path to BulletML XML source file
    /// </summary>
    [Export(PropertyHint.File, "*.xml")]
    public string SourceFile { get; private set; }

}
