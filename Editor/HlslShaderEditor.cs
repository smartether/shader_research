using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class HlslShaderEditor : UnityEditor.ShaderGUI
{
    Object vsBuff;
    Object psBuff;
    public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
    {
        base.AssignNewShaderToMaterial(material, oldShader, newShader);
    }

    public override void OnClosed(Material material)
    {
        base.OnClosed(material);
    }
    public static readonly string[] splitFlag = new string[] { ",\"", "\"," };
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        var matName = materialEditor.target.name;
        base.OnGUI(materialEditor, properties);
        if(vsBuff == null)
        {
            vsBuff = AssetDatabase.LoadAssetAtPath<TextAsset>(EditorPrefs.GetString(matName + "_ShaderVB_DBPath"));
            psBuff = AssetDatabase.LoadAssetAtPath<TextAsset>(EditorPrefs.GetString(matName + "_ShaderPB_DBPath"));
        }
        vsBuff = EditorGUILayout.ObjectField("vsBuff", vsBuff, typeof(TextAsset), false);
        psBuff = EditorGUILayout.ObjectField("psBuff", psBuff, typeof(TextAsset), false);

        if (GUILayout.Button("fill buff"))
        {
            var vsBuffPath = vsBuff == null? EditorPrefs.GetString(matName +"_ShaderVB","") : Application.dataPath.Replace("Assets", "") + AssetDatabase.GetAssetPath(vsBuff);
            EditorPrefs.SetString(matName + "_ShaderVB", vsBuffPath);
            EditorPrefs.SetString(matName + "_ShaderVB_DBPath", AssetDatabase.GetAssetPath(vsBuff));
            var psBuffPath = psBuff == null ? EditorPrefs.GetString(matName + "_ShaderPB", "") : Application.dataPath.Replace("Assets", "") + AssetDatabase.GetAssetPath(psBuff);
            EditorPrefs.SetString(matName + "_ShaderPB", psBuffPath);
            EditorPrefs.SetString(matName + "_ShaderPB_DBPath", AssetDatabase.GetAssetPath(psBuff));
            var lines = new List<string>( System.IO.File.ReadLines(vsBuffPath));
            lines.AddRange(System.IO.File.ReadLines(psBuffPath));
            for(int i=0,c=lines.Count;i<c;i++)
            {
                var line = lines[i];
                System.Type type = null;
                var nodes = line.Split(splitFlag, 3, System.StringSplitOptions.None);
                if(nodes.Length == 1)
                {
                    nodes = line.Split(',');
                }
                if (nodes.Length < 3)
                {
                    Debug.Log("## nodes len < 3, " + line);
                    continue;
                }
                var typeStr = nodes[2];
                var propName = nodes[0];
                var propValue = nodes[1];
                var mat = materialEditor.target as Material; 
                if (!string.IsNullOrEmpty(nodes[1]))
                {
                    var values = propValue.Split(',');
                    switch (typeStr)
                    {
                        case "float": type = typeof(float);
                            mat.SetFloat(propName, float.Parse(propValue));
                            break;
                        case "float2": type = typeof(Vector2);
                            mat.SetVector(propName, new Vector4(float.Parse(values[0].Trim(' ')), float.Parse(values[1].Trim(' ')), 0,0));
                            break;
                        case "float3": type = typeof(Vector3);
                            mat.SetVector(propName, new Vector4(float.Parse(values[0].Trim(' ')), float.Parse(values[1].Trim(' ')), float.Parse(values[2].Trim(' ')), 0));
                            break;
                        case "float4": type = typeof(Vector4);
                            mat.SetVector(propName, new Vector4(float.Parse(values[0].Trim(' ')), float.Parse(values[1].Trim(' ')), float.Parse(values[2].Trim(' ')), float.Parse(values[3].Trim(' '))));
                            break;
                    }
                }
                else
                {
                    if (typeStr == "float4x4 (column_major)")
                    {
                        var col1 = lines[i + 1];
                        var col2 = lines[i + 2];
                        var col3 = lines[i + 3];
                        var col4 = lines[i + 4];
                        Matrix4x4 openglMatrix = new Matrix4x4(
                            col1.toVector4(),
                            col2.toVector4(),
                            col3.toVector4(),
                            col4.toVector4()
                            );
                        var hlslMatrix = openglMatrix.transpose;
                        mat.SetMatrix(propName, hlslMatrix);
                        i += 4;
                    }
                    else
                    {
                        System.Text.RegularExpressions.Regex regexArray = new System.Text.RegularExpressions.Regex("float4\\[\\d+\\]");
                        if (regexArray.IsMatch(typeStr))
                        {
                            var m = regexArray.Match(line);
                            var spiType = m.Value.Split('[', ']');
                            var maxIdx = int.Parse(spiType[1]);
                            Vector4[] buffer = new Vector4[maxIdx];
                            for(int idx = 0; idx < maxIdx; idx++)
                            {
                                buffer[idx] = lines[i + idx + 1].toVector4();
                            }
                            mat.SetVectorArray(propName, buffer);
                            i+= maxIdx;
                        }
                    }
                }
            }
        }
    }

    public override void OnMaterialInteractivePreviewGUI(MaterialEditor materialEditor, Rect r, GUIStyle background)
    {
        base.OnMaterialInteractivePreviewGUI(materialEditor, r, background);
    }

    public override void OnMaterialPreviewGUI(MaterialEditor materialEditor, Rect r, GUIStyle background)
    {
        base.OnMaterialPreviewGUI(materialEditor, r, background);
    }

    public override void OnMaterialPreviewSettingsGUI(MaterialEditor materialEditor)
    {
        base.OnMaterialPreviewSettingsGUI(materialEditor);
    }

   

}

public static class stringExt
{
    public static Vector4 toVector4(this string str)
    {
        var values = str.Split(HlslShaderEditor.splitFlag, 3, System.StringSplitOptions.None);
        values = values[1].Split(',');
        var v = new Vector4(float.Parse(values[0].Trim(' ')), float.Parse(values[1].Trim(' ')), float.Parse(values[2].Trim(' ')), float.Parse(values[3].Trim(' ')));
        return v;
    }
}

