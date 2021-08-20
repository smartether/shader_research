using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawVector : MonoBehaviour
{
    public bool DisplayNormal;
    public bool DisplayTangent;
    public float vectorLen = 0.2f;

    [ContextMenu("PrintDir")]
    public void PrintVector()
    {
        Debug.Log(transform.forward);
    }

    private void OnDrawGizmosSelected()
    {
        var meshFilter = GetComponent<MeshFilter>();
        if(meshFilter != null)
        {
            var normals = meshFilter.sharedMesh.normals;
            var tangents = meshFilter.sharedMesh.tangents;
            var verties = meshFilter.sharedMesh.vertices;
            var mmatrix = gameObject.transform.localToWorldMatrix;
            for (int i = 0, c = verties.Length; i < c; i++)
            {

                var origin = mmatrix.MultiplyPoint(verties[i]);
                var normalws = Vector4.Normalize(mmatrix.MultiplyVector(normals[i]));
                var tangentws = Vector4.Normalize(mmatrix.MultiplyVector(tangents[i]));
                if (DisplayNormal)
                {
                    Gizmos.color = Color.yellow;
                    Gizmos.DrawLine(origin, origin + (Vector3)normalws * vectorLen);
                }
                if (DisplayTangent)
                {
                    Gizmos.color = Color.blue;
                    Gizmos.DrawLine(origin, origin + (Vector3)tangentws * vectorLen);
                }
                
            }
        }
        
    }
}
