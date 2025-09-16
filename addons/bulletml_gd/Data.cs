using BulletMLLib;
using Godot;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace bulletml_gd;

public partial class Data : Node {
    private static Data _instance;
    public static Data Instance { get { return _instance; } }

    /// <summary>
    /// Dictionary storing all loaded <see cref="BulletPattern"/> from <see cref="GDPattern"/> 
    /// </summary>
    private Dictionary<string, BulletPattern> patternCache = new Dictionary<string, BulletPattern>();


    /// <summary>
    /// Dictionary storing all <see cref="Node2D"/> references for <see cref="GDBullet"/>
    /// </summary>
    private Dictionary<string, Node2D> bulletCache = new Dictionary<string, Node2D>();

    /// <summary>
    /// Stores all loaded <see cref="BulletFunction"/> in a global cache
    /// </summary>
    private Dictionary<string, BulletFunction> functionCache = new Dictionary<string, BulletFunction>();

    /// <summary>
    /// List of all <see cref="GDPattern"/> to load into PatternStore
    /// </summary>
    [Export]
    public GDPattern[] patterns;


    /// <summary>
    /// List of all <see cref="GDBullet"/> to load into BulletStore
    /// </summary>
    [Export]
    public GDBullet[] bullets;


    public Data() {

    }


    public void LoadDatas(IBulletManager manager) {
        //Handle loading all GDPattern into cache
        foreach(var data in patterns) {
            if(data is not null) {
                LoadPattern(data, manager);
            }
        }

        //Load all GDBullet into cache
        foreach(var data in bullets) {
            if (data is not null) {
                LoadBullet(data);
            }
        }

        if(_instance == null) {
            _instance = this;
        }
    }

    public BulletPattern LoadPattern(GDPattern data, IBulletManager manager) {
        var pattern = new BulletPattern(manager);
        pattern.ParseXML(data.SourceFile.Replace("res://", ""));
        patternCache.Add(data.PatternID, pattern);
        return pattern;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="p_id"></param>
    /// <returns><see cref="BulletPattern"/></returns>
    public BulletPattern GetPattern(string p_id) {
        //Push a Warning to the console if the Pattern does not exist
        if(!patternCache.ContainsKey(p_id)) {
            GD.PushError($"No PatternID {p_id} in PatternCache!");
            return default;
        }

        return patternCache[p_id];
    }

    public void LoadBullet(GDBullet data){
        if (bulletCache.ContainsKey(data.BulletID)){
            GD.PushError($"BulletCache already contains a definition for {data.BulletID}");
            return;
        }

        var bullet = data.BulletScene.Instantiate() as Node2D;
        bulletCache.Add(data.BulletID, bullet);
    }

    /// <summary>
    /// Returns a copy of an instantiated <see cref="PackedScene"/>
    /// </summary>
    /// <param name="b_id"></param>
    /// <returns></returns>
    public Node2D GetBulletNode(string b_id){
        if(!bulletCache.ContainsKey(b_id)) {
            GD.PushError($"No BulletID {b_id} in BulletCache!");
            return default;
        }

        return bulletCache.GetValueOrDefault(b_id).Duplicate() as Node2D; 
    }

    public void CacheFunction(string key, BulletFunction function) { 
        if (!functionCache.ContainsKey(key)){
            functionCache.Add(key, function);
        }
    }

    public BulletFunction GetFunction(string func_id) {
        if(!functionCache.ContainsKey(func_id)) {
            GD.PushError($"No FunctionID {func_id} in Function Cache");
            return default;
        }
        return functionCache[func_id];
    }
}
