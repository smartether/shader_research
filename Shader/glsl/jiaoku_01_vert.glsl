#ifdef VERTEX

#define NEOX_USE_POSITION_INVARIANT 0	



#define World unity_ObjectToWorld
#define InverseWorld unity_WorldToObject
#define ViewProjection unity_MatrixVP

uniform vec4 LightProbeSHLow[3];
// uniform mat4 World;
// uniform mat4 InverseWorld;
// uniform mat4 ViewProjection;
uniform mat4 LightViewProj[4];

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 normal;
layout(location = 2) in vec4 diffuse;
layout(location = 3) in vec4 tangent;
layout(location = 4) in vec2 texcoord0;
layout(location = 1)out vec3 v2f_position_local;
layout(location = 2)out vec3 v2f_position_world;
layout(location = 3)out vec4 v2f_position_screen;
layout(location = 4)out vec4 v2f_vertex_color;
layout(location = 13)out vec3 v2f_normal;
layout(location = 5)out vec3 v2f_tangent;
layout(location = 6)out vec3 v2f_binormal;
layout(location = 7)out vec4 v2f_sh;
layout(location = 8)out vec4 v2f_sh2;
layout(location = 9)out vec4 v2f_uv;
layout(location = 10)out vec4 v2f_shadow_pos;
layout(location = 11)out vec3 v2f_lm_scale;
layout(location = 12)out vec3 v2f_lm_add;
layout(location=0) out vec4 gl_Position;

vec3 _1316;

void main()
{
    vec3 _812 = normalize(tangent.xyz);
    vec3 _1314;
    if (isnan(_812.x))
    {
        _1314 = vec3(1.0, 0.0, 0.0);
    }
    else
    {
        _1314 = _812;
    }
    vec4 _835 = position;
    vec4 _870 = World * _835;
    vec4 _964 = ViewProjection * _870;
    vec3 _896 = normalize(normal.xyz * mat3(InverseWorld[0].xyz, InverseWorld[1].xyz, InverseWorld[2].xyz));
    vec3 _908 = normalize(mat3(World[0].xyz, World[1].xyz, World[2].xyz) * _1314);
    vec4 _978 = vec4(_896, 1.0);
    vec3 _1301 = _1316;
    _1301.x = dot(LightProbeSHLow[0], _978);
    vec3 _1303 = _1301;
    _1303.y = dot(LightProbeSHLow[1], _978);
    vec3 _1305 = _1303;
    _1305.z = dot(LightProbeSHLow[2], _978);
    vec4 _1015 = vec4(-_896, 1.0);
    vec3 _1307 = _1316;
    _1307.x = dot(LightProbeSHLow[0], _1015);
    vec3 _1309 = _1307;
    _1309.y = dot(LightProbeSHLow[1], _1015);
    vec3 _1311 = _1309;
    _1311.z = dot(LightProbeSHLow[2], _1015);
    vec4 _1044 = LightViewProj[0] * _870;
    vec3 _940 = (_1044.xyz + vec3(_1044.w)) * 0.5;
    vec3 _956 = (_964.xyz + vec3(_964.w)) * 0.5;
    gl_Position = _964;
    v2f_position_local = _835.xyz;
    v2f_position_world = _870.xyz;
    v2f_position_screen = vec4(_956.x, _956.y, _956.z, _964.w);
    v2f_vertex_color = diffuse;
    v2f_normal = _896;
    v2f_tangent = _908;
    v2f_binormal = cross(_896, _908) * ((step(length(tangent.xyz), 2.0) * 2.0) - 1.0);
    v2f_sh = clamp(vec4(_1305.xyz, 1.0), vec4(0.0), vec4(10.0));
    v2f_sh2 = clamp(vec4(_1311,1.0), 0.0, 10.0);
    v2f_uv = vec4(texcoord0.x, texcoord0.y, vec4(0.0).z, vec4(0.0).w);
    v2f_shadow_pos = vec4(_940.x, _940.y, _940.z, _1044.w);
    v2f_lm_scale = vec3(0.0);
    v2f_lm_add = vec3(0.0);
}

#endif