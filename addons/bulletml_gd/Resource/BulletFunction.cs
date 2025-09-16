using Godot;
using System.Collections.Generic;

namespace bulletml_gd;

/// <summary>
/// Stores two <see cref="Expression"/> for X and Y components
/// </summary>
public enum CoordType{ 
    Carteesian,
    Polar,
}


[GlobalClass]
public partial class BulletFunction : Resource {
    

    [Export]
    public string FunctionID { get; private set; }

    [Export]
    public string XFuncStr;

    [Export]
    public string YFuncStr;

    [Export]
    public float Speed { get; set; } = 10f;

    [Export]
    public CoordType CoordType { get; set; } = CoordType.Polar;

    public Expression XFunc { get; set; }
    public Expression YFunc { get; set; }

    public BulletFunction() {
        XFunc = new Expression();
        YFunc = new Expression();
    }

    public void Parse(){
        var error = XFunc.Parse(XFuncStr, ["t"]);

        if(error != Error.Ok) {
            GD.PushWarning("Error parsing function x");
        }

        error = YFunc.Parse(YFuncStr, ["t"]);

        if(error != Error.Ok) {
            GD.PushWarning("Error parsing function y");
        }
        Data.Instance.CacheFunction(FunctionID, this);
    }
}

