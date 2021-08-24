using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class glVertexTest : MonoBehaviour
{
    Vector3[] vertices = new Vector3[4];
    int[] indices = new int[6];
    Mesh mesh = null;
    // Start is called before the first frame update
    void Start()
    {
        vertices[0] = new Vector4(-1, -1, 1);
        vertices[1] = new Vector4(-1, 1, 0);
        vertices[2] = new Vector4(1, -1, 0);
        vertices[3] = new Vector4(1, 1, 1);
        
        indices[0] = 0;
        indices[1] = 3;
        indices[2] = 1;

        indices[3] = 0;
        indices[4] = 2;
        indices[5] = 3;

        mesh = new Mesh();
        mesh.vertices = vertices;
        mesh.triangles = indices;
        mesh.RecalculateNormals();
        mesh.RecalculateTangents();

        var meshFilter = gameObject.AddComponent<MeshFilter>();
        var meshRender = gameObject.AddComponent<MeshRenderer>();
        meshFilter.sharedMesh = mesh;
        Debug.Log("$$ attach mesh success.");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
