using System.Collections.Generic;
using System.IO;
using BulletMLLib;
using Godot;

namespace bulletml_gd;

public partial class Main : Node2D {
    [Export]
    public PackedScene playerScene;

    [Export]
    public PackedScene bulletScene;

    // TODO: GameManager/Globals
    public static float ViewportWidth => Instance.GetViewportRect().Size.X;
    public static float ViewportHeight => Instance.GetViewportRect().Size.Y;
    public static Main Instance { get; private set; }


    private static Sprite2D playerInstance; // TODO: PlayerManager

    private Data assets;

    public Main() {
        Instance = this;
    }

    public static Vector2 GetPlayerPosition() {
        return playerInstance?.Position
            ?? new Vector2(Instance.GetViewportRect().Size.X / 2f, Instance.GetViewportRect().Size.Y - 100f);
    }

    public override void _Ready() {
        base._Ready();

        CallDeferred(nameof(_LateReady));
    }

    private void _LateReady() {
        GameManager.GameDifficulty = () => 1.0f;

        // Add a dummy player sprite
        var scene = ResourceLoader.Load<PackedScene>(playerScene.ResourcePath);
        if(scene.Instantiate() is not Sprite2D player)
            return;
        playerInstance = player;
        player.Position = new(GetViewportRect().Size.X / 2f, GetViewportRect().Size.Y - 100f);
        AddChild(player);
    }

    float counter = 0;
    public override void _Process(double bigDelta) {

    }
}
