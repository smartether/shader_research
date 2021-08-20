float4 gl_Position;
float3 tangent_in;
float3 position;
float3 normal_in;
float3 v2f_position_local;
float3 v2f_position_world;
float4 v2f_position_screen;
float4 v2f_vertex_color;
float4 diffuse;
float3 v2f_normal;
float3 v2f_tangent;
float3 v2f_binormal;
float4 v2f_sh;
float4 v2f_sh2;
float4 v2f_uv;
float2 texcoord0;
float4 v2f_shadow_pos;
float3 v2f_lm_scale;
float3 v2f_lm_add;

struct STAttribute
{
    float3 position : POSITION;
    float3 normal_in : NORMAL;
    float4 diffuse : Color;
    float3 tangent_in : TANGENT;
    float2 texcoord0 : TEXCOORD0;
};

#ifndef _STVARING_
#define _STVARING_
struct STVaring
{
    float3 v2f_position_local : TEXCOORD1;
    float3 v2f_position_world : TEXCOORD2;
    float4 v2f_position_screen : TEXCOORD3;
    float4 v2f_vertex_color : TEXCOORD4;
    float3 v2f_tangent : TEXCOORD5;
    float3 v2f_binormal : TEXCOORD6;
    float4 v2f_sh : TEXCOORD7;
    float4 v2f_sh2 : TEXCOORD8;
    float4 v2f_uv : TEXCOORD9;
    float4 v2f_shadow_pos : TEXCOORD10;
    float3 v2f_lm_scale : TEXCOORD11;
    float3 v2f_lm_add : TEXCOORD12;
    float3 v2f_normal : TEXCOORD13;
    float4 gl_Position : SV_Position;
};

#endif
// static float4x4 World;
// static float4x4 ViewProjection;
// static float4x4 InverseWorld;
// static float3 _1316;
// static float4 LightProbeSHLow[3];
// static float4x4 LightViewProj[4];
uniform float4x4 unity_WorldToLight;

void vert_main()
{
    float3 _812 = normalize(tangent_in);
    float3 _1314;
    if (isnan(_812.x))
    {
        _1314 = float3(1.0f, 0.0f, 0.0f);
    }
    else
    {
        _1314 = _812;
    }
    float4 _835 = float4(position, 1.0f);
    float4 _870 = mul(World,_835);
    float4 _964 = mul(ViewProjection, _870);
    float3 _896 = normalize(mul((float3x3)World,normal_in));//,(float3x3)InverseWorld));
    float3 _908 = normalize(mul((float3x3)World,_1314));
    float4 _978 = float4(_896, 1.0f);
    float3 _1301 = _1316;
    _1301.x = dot(LightProbeSHLow[0], _978);
    float3 _1303 = _1301;
    _1303.y = dot(LightProbeSHLow[1], _978);
    float3 _1305 = _1303;
    _1305.z = dot(LightProbeSHLow[2], _978);
    float4 _1015 = float4(-_896, 1.0f);
    float3 _1307 = _1316;
    _1307.x = dot(LightProbeSHLow[0], _1015);
    float3 _1309 = _1307;
    _1309.y = dot(LightProbeSHLow[1], _1015);
    float3 _1311 = _1309;
    _1311.z = dot(LightProbeSHLow[2], _1015);

    half3 shcol = SampleSHVertex(_896);

    float4x4 lightViewProj = unity_WorldToLight;
    float4 _1044 = mul(lightViewProj, _870);
    float3 _940 = (_1044.xyz + _1044.w.xxx) * 0.5f;
    float3 _956 = (_964.xyz + _964.w.xxx) * 0.5f;
    gl_Position = _964;
    v2f_position_local = _835.xyz;
    v2f_position_world = _870.xyz;
    v2f_position_screen = float4(_956.x, _956.y, _956.z, _964.w);
    v2f_vertex_color = diffuse;
    v2f_normal = _896;
    v2f_tangent = _908;
    v2f_binormal = cross(_896, _908) * ((step(length(tangent_in), 2.0f) * 2.0f) - 1.0f);
    v2f_sh = clamp(float4(_1305, 1.0f), 0.0f.xxxx, 10.0f.xxxx);
    v2f_sh = clamp(float4(shcol, 1.0f), 0.0, 10.0);
    v2f_sh2 = clamp(float4(_1311, 1.0f), 0.0f.xxxx, 10.0f.xxxx);
    v2f_uv = float4(texcoord0.x, texcoord0.y, 0.0f, 0.0f);
    v2f_shadow_pos = float4(_940.x, _940.y, _940.z, _1044.w);
    v2f_lm_scale = 0.0f.xxx;
    v2f_lm_add = 0.0f.xxx;
}

STVaring vs_main(STAttribute stage_input)
{
    tangent_in = stage_input.tangent_in;
    position = stage_input.position;
    normal_in = stage_input.normal_in;
    diffuse = stage_input.diffuse;
    texcoord0 = stage_input.texcoord0;
    vert_main();
    STVaring stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.v2f_position_local = v2f_position_local;
    stage_output.v2f_position_world = v2f_position_world;
    stage_output.v2f_position_screen = v2f_position_screen;
    stage_output.v2f_vertex_color = v2f_vertex_color;
    stage_output.v2f_normal = v2f_normal;
    stage_output.v2f_tangent = v2f_tangent;
    stage_output.v2f_binormal = v2f_binormal;
    stage_output.v2f_sh = v2f_sh;
    stage_output.v2f_sh2 = v2f_sh2;
    stage_output.v2f_uv = v2f_uv;
    stage_output.v2f_shadow_pos = v2f_shadow_pos;
    stage_output.v2f_lm_scale = v2f_lm_scale;
    stage_output.v2f_lm_add = v2f_lm_add;
    return stage_output;
}
