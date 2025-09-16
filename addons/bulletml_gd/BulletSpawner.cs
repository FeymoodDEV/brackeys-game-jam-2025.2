using BulletMLLib;
using Equationator;
using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using bulletml_gd;

public partial class BulletSpawner : Node2D, IBulletManager {
    private const float timeSpeed = 1.0f;
    private const float scale = 1.0f;

    private readonly List<NodeBullet> movers = new List<NodeBullet>();
    private readonly List<NodeBullet> topLevelMovers = new List<NodeBullet>();

    private PositionDelegate GetPlayerPosition;
    private PositionDelegate GetMousePosition;

    private Expression path;


    [Export]
    public PackedScene bulletScene;

    [Export]
    public string patternID;

    [Export]
    public BulletFunction[] BulletFunctions;

    public Random Rand { get; private set; } = new Random(Guid.NewGuid().GetHashCode());
    public Dictionary<string, FunctionDelegate> CallbackFunctions { get; set; } = new Dictionary<string, FunctionDelegate>();


    public double Difficulty { get; set; }
    public FunctionDelegate GameDifficulty => () => 0.5;

    private double currentDelta = 0;
    public FunctionDelegate CurrentDelta { get => () => currentDelta; }

    public Queue<NodeBullet> moverPool => new Queue<NodeBullet>();

    private Data assets;

    private MarkupBullet topLevelBullet;

    public BulletSpawner() {
    
    }

    public override void _Ready() {
        assets = GetNode<Data>("/root/Data");

        CallDeferred("_LateReady");
    }

    private void _LateReady() {
        GameManager.GameDifficulty = () => 1.0f;
        assets.LoadDatas(this);

        // Setup PlayerPosition and MousePosition delegates
        // Allows BulletPatterns to reference their position
        GetPlayerPosition = new PositionDelegate(Main.GetPlayerPosition);
        GetMousePosition = new PositionDelegate(GetGlobalMousePosition);

        foreach(var func in BulletFunctions) {
            func.Parse();
        }
    }

    float counter = 0;
    public override void _Process(double bigDelta) {
        var delta = (float)bigDelta;
        base._Process(delta);

        Update(delta);
        PostUpdate();

    }

    public void Spawn(float x, float y) {
        Spawn(patternID, new Vector2(x, y));
    }

    /// <summary>
    /// Spawns the currently loaded Pattern offset by X, and Y
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    public void Spawn(string patternID, float x, float y){
        Spawn(patternID, new Vector2(x, y));
    }

    public void Spawn(string patternID, Vector2 offset = default) {
        BulletPattern pat;

        //Create the TopLevel Bullet at the Position of the Spawner
        topLevelBullet = (MarkupBullet)CreateTopBullet();
        topLevelBullet.Position = GlobalPosition;

        pat = assets.GetPattern(patternID);

        if(pat != null) {
            pat.BulletManager = this;
            topLevelBullet.InitTopNode(pat.RootNode);
        }else{
            GD.PushError(Name + $"(BulletSpawner): Referenced BulletPattern {patternID} does not exist");
        }
    }

    public void Update(float delta) {
        for(var i = 0; i < movers.Count; i++) {
            movers[i].Update();
        }

        for(var i = 0; i < topLevelMovers.Count; i++) {
            topLevelMovers[i].Update();
        }
        currentDelta += Time.PhysicsDelta;
        FreeMovers();
    }

    private void FreeMovers() {
        for(var i = 0; i < movers.Count; i++) {
            if(movers[i].Used)
                continue;

            moverPool.Enqueue(movers[i]);
            movers.RemoveAt(i);
            i--;
        }

        //clear out top level bullets
        for(var i = 0; i < topLevelMovers.Count; i++) {
            if(!topLevelMovers[i].TasksFinished())
                continue;

            topLevelMovers.RemoveAt(i);
            i--;
        }
    }

    public Vector2 PlayerPosition(IBullet targettedBullet) {
        //just give the player's position
        Debug.Assert(null != GetPlayerPosition);
        return GetPlayerPosition();
    }

    public void RemoveBullet(IBullet deadBullet) {
        if(deadBullet is NodeBullet myMover) {
            myMover.Used = false;
        }
    }

    /// <summary>
    /// Spawns a <see cref="FunctionBullet"/> that will follow the path 
    /// of the referenced <see cref="BulletFunctions"/>
    /// </summary>
    /// <param name="id"></param>
    public void SpawnFunction(string id){
        SpawnFunction(id, 0, 0);
    }

    public void SpawnFunction(string id, float x, float y){
        NodeBullet mover;
        var func = Data.Instance.GetFunction(id);
        //Load sample cos and sin functions into the BulletFunction
        mover = new FunctionBullet(this, func) { TimeSpeed = timeSpeed, Scale = scale };
        mover.Position = GlobalPosition;
        (mover as FunctionBullet).Offset = new Vector2(x, y);
        mover.Init(this);


        //initialize, store in our list, and return the bullet    
        movers.Add(mover);
    }

    public IBullet CreateBullet() {
        NodeBullet mover;
        if (moverPool.Count == 0){
            mover = new MarkupBullet(this) { TimeSpeed = timeSpeed, Scale = scale };
            mover.Init(this);
        } else{
            mover = moverPool.Dequeue();
        }

        //initialize, store in our list, and return the bullet    
        movers.Add(mover);
        return mover;
    }

    public IBullet CreateTopBullet() {
        var mover = new MarkupBullet(this) { TimeSpeed = timeSpeed, Scale = scale };

        //initialize, store in our list, and return the bullet
        mover.Init(this);
        topLevelMovers.Add(mover);
        return mover;
    }

    public double Tier() {
        return 0.0;
    }

    public void Clear() {
        movers.Clear();
        topLevelMovers.Clear();
        currentDelta = 0;
    }

    public void PostUpdate() {
        // TODO: use godot game loop
        foreach(var t in movers) {
            t.PostUpdate();
        }

        foreach(var t in topLevelMovers) {
            t.PostUpdate();
        }
    }

    public float GetCurrentTick() {
        throw new NotImplementedException();
    }

    public List<NodeBullet> GetBullets() {
        return movers;
    }
}
