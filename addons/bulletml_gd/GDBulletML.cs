#if TOOLS
using Godot;
using System;

[Tool]
public partial class GDBulletML : EditorPlugin
{

	private static Time time;

	public override void _EnterTree()
	{
		time = Time.Instance;
		// Initialization of the plugin goes here.
	}

	public override void _ExitTree()
	{
		// Clean-up of the plugin goes here.
	}
}
#endif
