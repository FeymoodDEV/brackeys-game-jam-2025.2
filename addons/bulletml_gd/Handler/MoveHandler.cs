using System;
using System.Collections.Generic;
using System.Diagnostics;
using BulletMLLib;
using Equationator;
using Godot;

namespace bulletml_gd;

/// <summary>
/// MoveManager - represents a bullet manager, i.e. something generating bullets such as an enemy character.
/// </summary>
public partial class MoveHandler : Node2D , IBulletManager {
    private const float timeSpeed = 1.0f;
    private const float scale = 1.0f;

    private readonly List<NodeBullet> movers = new();
    private readonly List<NodeBullet> topLevelMovers = new();

    private readonly PositionDelegate GetPlayerPosition;
    private readonly PackedScene bulletScene;

    public Random Rand { get; private set; } = new Random(Guid.NewGuid().GetHashCode());
    public Dictionary<string, FunctionDelegate> CallbackFunctions { get; set; } = new Dictionary<string, FunctionDelegate>();


    public double Difficulty { get; set; }
    public FunctionDelegate GameDifficulty => () => 0.5;

    private double currentDelta = 0;
    public FunctionDelegate CurrentDelta { get => () => currentDelta; }

    public Queue<NodeBullet> moverPool => throw new NotImplementedException();

    public MoveHandler(PositionDelegate playerPosition, PackedScene bulletScene)
    {
        Debug.Assert(playerPosition != null);
        GetPlayerPosition = playerPosition;
        this.bulletScene = bulletScene;
    }

    public void Update(float delta)
    {
        for (var i = 0; i < movers.Count; i++)
        {
            movers[i].Update();
        }

        for (var i = 0; i < topLevelMovers.Count; i++)
        {
            topLevelMovers[i].Update();
        }
        currentDelta += Time.PhysicsDelta;
        FreeMovers();
    }

    private void FreeMovers()
    {
        for (var i = 0; i < movers.Count; i++)
        {
            if (movers[i].Used)
                continue;

            movers.RemoveAt(i);
            i--;
        }

        //clear out top level bullets
        for (var i = 0; i < topLevelMovers.Count; i++)
        {
            if (!topLevelMovers[i].TasksFinished())
                continue;

            topLevelMovers.RemoveAt(i);
            i--;
        }
    }

    public Vector2 PlayerPosition(IBullet targettedBullet)
    {
        //just give the player's position
        Debug.Assert(null != GetPlayerPosition);
        return GetPlayerPosition();
    }

    public void RemoveBullet(IBullet deadBullet)
    {
        if (deadBullet is MarkupBullet myMover)
        {
            myMover.Used = false;
        }
    }

    public IBullet CreateBullet()
    {
        var mover = new MarkupBullet(this) { TimeSpeed = timeSpeed, Scale = scale };

        //initialize, store in our list, and return the bullet
        mover.Init(this);
        movers.Add(mover);
        return mover;
    }

    public IBullet CreateTopBullet()
    {
        var mover = new MarkupBullet(this) { TimeSpeed = timeSpeed, Scale = scale };

        //initialize, store in our list, and return the bullet
        mover.Init(this);
        topLevelMovers.Add(mover);
        return mover;
    }

    public double Tier()
    {
        return 0.0;
    }

    public void Clear()
    {
        movers.Clear();
        topLevelMovers.Clear();
        currentDelta = 0;
    }

    public void PostUpdate()
    {
        // TODO: use godot game loop
        foreach (var t in movers)
        {
            t.PostUpdate();
        }

        foreach (var t in topLevelMovers)
        {
            t.PostUpdate();
        }
    }

    public float GetCurrentTick() {
        throw new NotImplementedException();
    }

    public List<NodeBullet> GetMovers() {
        throw new NotImplementedException();
    }

    public List<NodeBullet> GetBullets() {
        throw new NotImplementedException();
    }
}
