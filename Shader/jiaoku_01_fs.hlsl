Texture2D<float4> Tex0 : register(t0);
SamplerState _Tex0_sampler : register(s0);
Texture2D<float4> Tex1 : register(t1);
SamplerState _Tex1_sampler : register(s1);
Texture2D<float4> Tex2 : register(t2);
SamplerState _Tex2_sampler : register(s2);
Texture2D<float4> DetailTex : register(t3);
SamplerState _DetailTex_sampler : register(s3);
Texture2D<float4> ShadowMap : register(t4);
SamplerState _ShadowMap_sampler : register(s4);
TextureCube<float4> ReflectionProbeA : register(t5);
SamplerState _ReflectionProbeA_sampler : register(s5);
TextureCube<float4> ReflectionProbeB : register(t6);
SamplerState _ReflectionProbeB_sampler : register(s6);

// static float3 v2f_position_world;
// static float4 v2f_uv;
// static float3 v2f_tangent;
// static float3 v2f_binormal;
// static float3 v2f_normal;
// static float4 v2f_shadow_pos;
// static float4 v2f_sh;
float4 _entryPointOutput;

#ifndef _STVARING_
#define _STVARING_
struct STVaring
{
    float4 v2f_shadow_pos : TEXCOORD0;
    float3 v2f_position_world : TEXCOORD2;
    float3 v2f_tangent : TEXCOORD3;
    float3 v2f_binormal : TEXCOORD6;
    float4 v2f_sh : TEXCOORD7;
    float4 v2f_uv : TEXCOORD9;
    float3 v2f_normal : TEXCOORD13;
};

#endif
struct STTargets
{
    float4 _entryPointOutput : SV_Target0;
};

// static float3 CameraPosition;
// static float DetailTexTilling;
// static float4 BaseColor;
// static float DetailNormalIntensity;
// static float4 Intensity;
// static float4 DirLightAttr[5];
// static float4 ShadowInfo;
// static int PointLightNonShadowNum;
// static float4 PointLightAttrs[5];
// static int SpotLightNonShadowNum;
// static float4 SpotLightAttrs[9];
// static float4 FillLightDirection;
// static float4 FillLightColor;
// static float4 ReflectionProbeInfo;
// static float4 ReflectionProbeBoxProjA[3];
// static int2 ReflectionProbeNormalized;
// static float4 ReflectionProbeBoxProjB[3];
// static float2 ColorAdjust;
// static float AlphaMtl;
uniform float4 _WorldSpaceLightPos0;

#define FillLightColor _MainLightColor

void frag_main()
{
    // _entryPointOutput = abs(float4(0.5 * (v2f_normal + 1),1));
    // return;
    DirLightAttr[1] = AdditionLightColor;
    DirLightAttr[3] = AdditionLightDir;// normalize(_MainLightPosition);
    float3 _2128 =   v2f_position_world - _WorldSpaceCameraPos;
    float3 _2139 = _2128 / length(_2128).xxx;
    float4 _2219 = Tex0.Sample(_Tex0_sampler, v2f_uv.xy);
    float4 _2226 = Tex1.Sample(_Tex1_sampler, v2f_uv.xy);
    float4 _2233 = Tex2.Sample(_Tex2_sampler, v2f_uv.xy);
    float4 _2242 = DetailTex.Sample(_DetailTex_sampler, v2f_uv.xy * DetailTexTilling);
    float2 _2260 = lerp(_2233.xy, _2242.wz, _2226.z.xx);
    float3 _2326 = _2219.xyz * BaseColor.xyz;
    float3 _2353 = (_2226.xyz * 2.0f) - 1.0f.xxx;
    float3 _5355 = _2353;
    _5355.z = sqrt(1.0f - dot(_2353.xy, _2353.xy));
    float2 _2397 = ((_2242.xy * 2.0f) - 1.0f.xx) * (DetailNormalIntensity * _2226.z);
    float4 _5357 = float4(_2397.x, _2397.y, _2242.z, _2242.w);
    _5357.z = sqrt(1.0f - dot(_2397, _2397));
    float3 _2423 = normalize(float3(_5355.xy + _5357.xy, _5355.z));
    float2 _2362 = _2423.xy * Intensity.x;
    
    float3 _2372 = normalize(mul(normalize(float3(_2362.x, _2362.y, _2423.z)), float3x3(float3(v2f_tangent), float3(v2f_binormal), float3(v2f_normal))));
    // _entryPointOutput = float4(v2f_normal, 1);
    // return;

    // unity tangentToWorld
    //float3x3 tangentToWorld = CreateTangentToWorld(v2f_normal, v2f_tangent, 1);
    //_2372 = normalize(TransformTangentToWorld(normalize(float3(_2362.x, _2362.y, _2423.z)), tangentToWorld));

    float3 _2444 = ddx(_2372);
    float3 _2446 = ddy(_2372);
    float _2297 = max(clamp(_2260.y * Intensity.y, 0.0900000035762786865234375f, 1.0f), clamp((pow(max(max(dot(_2444, _2444), dot(_2446, _2446)), 9.9999997473787516355514526367188e-05f), 0.5f) * 2.0f) - 0.20000000298023223876953125f, 0.0f, 1.0f));
    float _2467 = clamp(_2233.z * Intensity.z, 0.0f, 1.0f);
    float _2470 = _2260.x;
    float _2472 = _2226.w;
    float _2576 = dot(-_2139, _2372);
    float _2582 = clamp(abs(_2576) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
    float3 _2602 = lerp(0.039999999105930328369140625f.xxx, _2326, _2467.xxx);
    float3 _2607 = _2326 * (1.0f - _2467);
    float _2589 = max(0.00999999977648258209228515625f, _2297);
    float _2611 = _2589 * _2589;
    float3 _2594 = reflect(_2139, _2372);
    float3 _5267 = 0.0f.xxx;
    float3 _5266 = 0.0f.xxx;
    float3 _5338;
    float3 _5337;
    float _5310;
    float _5322;
    
        float4 shadowCoord = TransformWorldToShadowCoord(v2f_position_world);
        float shadowColor = MainLightRealtimeShadow(shadowCoord);
        // float4 shadowCoord = TransformWorldToShadowCoord(v2f_position_world);
        // float shadowColor = MainLightRealtimeShadow(shadowCoord);
        //  _entryPointOutput = shadowColor;
        //  return;
    for (int _5264 = 0; _5264 < 1; _5267 = _5338, _5266 = _5337, _5264++)
    {
        float _2654 = dot(_2372, -DirLightAttr[3].xyz);
        if (_2654 <= 0.0f)
        {
            _5338 = _5267;
            _5337 = _5266;
            continue;
        }
/*
        float4 _2742 = v2f_shadow_pos / v2f_shadow_pos.w.xxxx;
        float3 _2744 = _2742.xyz;
        if (_2744.z > 1.0f)
        {
            _5310 = 1.0f;
        }
        else
        {
            _5310 = (ShadowMap.SampleLevel(_ShadowMap_sampler, _2742.xy, 0.0f).x < _2744.z) ? 0.0f : 1.0f;
            _5310 = shadowColor;
        }
*/
        _5310 = shadowColor;
        float _2669 = _5310 + ShadowInfo.w;
        float _2673 = min(1.0f, clamp(_2669, 0.0f, 1.0f));
        float _2771 = max(_2654, 0.0f);
        float _2775 = dot(DirLightAttr[3].xyz, _2139);
        float _2780 = rsqrt(max(2.0f + (2.0f * _2775), 9.9999997473787516355514526367188e-06f));
        float _2800 = 1.0f - clamp(_2780 + (_2780 * _2775), 0.0f, 1.0f);
        float _2816 = _2800 * _2800;
        float _2821 = (_2816 * _2816) * _2800;
        float _2886 = _2611 * _2611;
        float _2888 = min(0.999000012874603271484375f, clamp((_2654 + _2576) * _2780, 0.0f, 1.0f));
        float _2896 = (((_2888 * _2886) - _2888) * _2888) + 1.0f;
        if ((_2673 <= 1.0f) && (_2673 >= 0.0f))
        {
            _5322 = _2673;
        }
        else
        {
            _5322 = 1.0f;
        }
        _5338 = _5267 + ((((_2771.xxx * _2607) * 1.0f) * _5322) * DirLightAttr[1].xyz);
        _5337 = _5266 + ((((max(0.0f, ((0.5f / max((_2771 * ((_2582 * (1.0f - _2611)) + _2611)) + (_2582 * ((_2771 * (1.0f - _2611)) + _2611)), 9.9999997473787516355514526367188e-06f)) * (_2886 / ((3.1415927410125732421875f * _2896) * _2896))) * _2771).xxx * ((clamp(50.0f * _2602.y, 0.0f, 1.0f) * _2821).xxx + (_2602 * (1.0f - _2821)))) * 1.0f) * _5322) * DirLightAttr[1].xyz);
    }
    float3 _5282;
    float3 _5281;
    if (min(PointLightNonShadowNum, 1) == 1)
    {
        float3 _2949 = v2f_position_world - PointLightAttrs[3].xyz;
        float _2953 = length(_2949);
        float3 _2958 = _2949 / _2953.xxx;
        float _2964 = dot(_2372, -_2958);
        float3 _5270;
        float3 _5269;
        if (!(_2964 <= 0.0f))
        {
            float _3025 = max(_2964, 0.0f);
            float _3029 = dot(_2958, _2139);
            float _3034 = rsqrt(max(2.0f + (2.0f * _3029), 9.9999997473787516355514526367188e-06f));
            float _3054 = 1.0f - clamp(_3034 + (_3034 * _3029), 0.0f, 1.0f);
            float _3070 = _3054 * _3054;
            float _3075 = (_3070 * _3070) * _3054;
            float _3085 = _2953 * _2953;
            float _3091 = (_3085 * PointLightAttrs[3].w) * PointLightAttrs[3].w;
            float _3094 = clamp(1.0f - (_3091 * _3091), 0.0f, 1.0f);
            float _3098 = (1.0f / (_3085 + 1.0f)) * (_3094 * _3094);
            float _3171 = _2611 * _2611;
            float _3173 = min(0.999000012874603271484375f, clamp((_2964 + _2576) * _3034, 0.0f, 1.0f));
            float _3181 = (((_3173 * _3171) - _3173) * _3173) + 1.0f;
            _5270 = _5267 + ((((_3025.xxx * _2607) * _3098) * PointLightAttrs[1].xyz) * _2472);
            _5269 = _5266 + ((((max(0.0f, ((0.5f / max((_3025 * ((_2582 * (1.0f - _2611)) + _2611)) + (_2582 * ((_3025 * (1.0f - _2611)) + _2611)), 9.9999997473787516355514526367188e-06f)) * (_3171 / ((3.1415927410125732421875f * _3181) * _3181))) * _3025).xxx * ((clamp(50.0f * _2602.y, 0.0f, 1.0f) * _3075).xxx + (_2602 * (1.0f - _3075)))) * _3098) * PointLightAttrs[1].xyz) * _2472);
        }
        else
        {
            _5270 = _5267;
            _5269 = _5266;
        }
        _5282 = _5270;
        _5281 = _5269;
    }
    else
    {
        _5282 = _5267;
        _5281 = _5266;
    }
    float3 _5297;
    float3 _5296;
    if (min(SpotLightNonShadowNum, 1) == 1)
    {
        float3 _3236 = v2f_position_world - SpotLightAttrs[3].xyz;
        float _3240 = length(_3236);
        float3 _3245 = _3236 / _3240.xxx;
        float _3251 = dot(_2372, -_3245);
        float3 _5285;
        float3 _5284;
        if (!(_3251 <= 0.0f))
        {
            float3 _3274 = SpotLightAttrs[1].xyz * 16.0f;
            float _3330 = max(_3251, 0.0f);
            float _3334 = dot(_3245, _2139);
            float _3339 = rsqrt(max(2.0f + (2.0f * _3334), 9.9999997473787516355514526367188e-06f));
            float _3359 = 1.0f - clamp(_3339 + (_3339 * _3334), 0.0f, 1.0f);
            float _3375 = _3359 * _3359;
            float _3380 = (_3375 * _3375) * _3359;
            float _3390 = _3240 * _3240;
            float _3396 = (_3390 * SpotLightAttrs[3].w) * SpotLightAttrs[3].w;
            float _3399 = clamp(1.0f - (_3396 * _3396), 0.0f, 1.0f);
            float _3426 = clamp((dot(-_3245, -normalize(SpotLightAttrs[0].xyz)) - SpotLightAttrs[4].x) * SpotLightAttrs[4].y, 0.0f, 1.0f);
            float _3292 = (_3426 * _3426) * ((1.0f / (_3390 + 1.0f)) * (_3399 * _3399));
            float _3496 = _2611 * _2611;
            float _3498 = min(0.999000012874603271484375f, clamp((_3251 + _2576) * _3339, 0.0f, 1.0f));
            float _3506 = (((_3498 * _3496) - _3498) * _3498) + 1.0f;
            _5285 = _5282 + (((_3330.xxx * _2607) * _3292) * _3274);
            _5284 = _5281 + (((max(0.0f, ((0.5f / max((_3330 * ((_2582 * (1.0f - _2611)) + _2611)) + (_2582 * ((_3330 * (1.0f - _2611)) + _2611)), 9.9999997473787516355514526367188e-06f)) * (_3496 / ((3.1415927410125732421875f * _3506) * _3506))) * _3330).xxx * ((clamp(50.0f * _2602.y, 0.0f, 1.0f) * _3380).xxx + (_2602 * (1.0f - _3380)))) * _3292) * _3274);
        }
        else
        {
            _5285 = _5282;
            _5284 = _5281;
        }
        _5297 = _5285;
        _5296 = _5284;
    }
    else
    {
        _5297 = _5282;
        _5296 = _5281;
    }
    float3 _5303;
    float3 _5302;
    for (;;)
    {
        float3 _3546 = -(_MainLightPosition.xyz / length(_MainLightPosition.xyz));//normalize(_MainLightPosition).xyzw;
        float _3552 =dot(_2372, -_3546);

        if (_3552 <= 0.0f)
        {
            _5303 = _5297;
            _5302 = _5296;
            break;
        }
        float _3605 = max(_3552, 0.0f);
        float _3609 = dot(_3546, _2139);

        float _3614 = rsqrt(max(2.0f + (2.0f * _3609), 9.9999997473787516355514526367188e-06f));
        float _3634 = 1.0f - clamp(_3614 + (_3614 * _3609), 0.0f, 1.0f);
        float _3650 = _3634 * _3634;
        float _3655 = (_3650 * _3650) * _3634;
        float _3720 = _2611 * _2611;
        float _3722 = min(0.999000012874603271484375f, clamp((_3552 + _2576) * _3614, 0.0f, 1.0f));
        float _3730 = (((_3722 * _3720) - _3722) * _3722) + 1.0f;
        _5303 = _5297 + ((((_3605.xxx * _2607) * 1.0f) * FillLightColor.xyz * unity_LightData.z) * 1.0f);
        _5302 = _5296 + ((((max(0.0f, ((0.5f / max((_3605 * ((_2582 * (1.0f - _2611)) + _2611)) + (_2582 * ((_3605 * (1.0f - _2611)) + _2611)), 9.9999997473787516355514526367188e-06f)) * (_3720 / ((3.1415927410125732421875f * _3730) * _3730))) * _3605).xxx * ((clamp(50.0f * _2602.y, 0.0f, 1.0f) * _3655).xxx + (_2602 * (1.0f - _3655)))) * 1.0f) * FillLightColor.xyz * unity_LightData.z) * 1.0f);
        break;
    }
    float3 _2540 = _5303 * 0.3183099925518035888671875f;
    float4 _5308;
    if (ReflectionProbeInfo.x > 0.0f)
    {
        float3 _5416;
        if (ReflectionProbeBoxProjA[0].x > 0.0f)
        {
            float3 _3865 = (ReflectionProbeBoxProjA[1].xyz - v2f_position_world) / _2594;
            float3 _3870 = (ReflectionProbeBoxProjA[2].xyz - v2f_position_world) / _2594;
            float3 _5372 = _3865;
            float _1050;
            if (_2594.x > 0.0f)
            {
                _1050 = _3865.x;
            }
            else
            {
                _1050 = _3870.x;
            }
            _5372.x = _1050;
            float3 _5377 = _5372;
            float _1065;
            if (_2594.y > 0.0f)
            {
                _1065 = _3865.y;
            }
            else
            {
                _1065 = _3870.y;
            }
            _5377.y = _1065;
            float3 _5382 = _5377;
            float _1080;
            if (_2594.z > 0.0f)
            {
                _1080 = _3865.z;
            }
            else
            {
                _1080 = _3870.z;
            }
            _5382.z = _1080;
            _5416 = (v2f_position_world - ReflectionProbeBoxProjA[0].yzw) + (_2594 * min(min(_5382.x, _5382.y), _5382.z));
        }
        else
        {
            _5416 = _2594;
        }
        float4 _3799 = ReflectionProbeA.SampleLevel(_ReflectionProbeA_sampler, _5416, _2297 * ReflectionProbeInfo.y);
        float4 _5307;
        if (ReflectionProbeNormalized.x == 1)
        {
            float3 _3807 = _3799.xyz * v2f_sh.xyz;
            _5307 = float4(_3807.x, _3807.y, _3807.z, _3799.w);
        }
        else
        {
            _5307 = _3799;
        }
        float4 _5309;
        if (ReflectionProbeInfo.x < 0.999989986419677734375f)
        {
            float3 _5417;
            if (ReflectionProbeBoxProjB[0].x > 0.0f)
            {
                float3 _3929 = (ReflectionProbeBoxProjB[1].xyz - v2f_position_world) / _2594;
                float3 _3934 = (ReflectionProbeBoxProjB[2].xyz - v2f_position_world) / _2594;
                float3 _5390 = _3929;
                float _1181;
                if (_2594.x > 0.0f)
                {
                    _1181 = _3929.x;
                }
                else
                {
                    _1181 = _3934.x;
                }
                _5390.x = _1181;
                float3 _5395 = _5390;
                float _1196;
                if (_2594.y > 0.0f)
                {
                    _1196 = _3929.y;
                }
                else
                {
                    _1196 = _3934.y;
                }
                _5395.y = _1196;
                float3 _5400 = _5395;
                float _1211;
                if (_2594.z > 0.0f)
                {
                    _1211 = _3929.z;
                }
                else
                {
                    _1211 = _3934.z;
                }
                _5400.z = _1211;
                _5417 = (v2f_position_world - ReflectionProbeBoxProjB[0].yzw) + (_2594 * min(min(_5400.x, _5400.y), _5400.z));
            }
            else
            {
                _5417 = _2594;
            }
            float4 _3831 = ReflectionProbeB.SampleLevel(_ReflectionProbeB_sampler, _5417, _2297 * ReflectionProbeInfo.z);
            float4 _5304;
            if (ReflectionProbeNormalized.y == 1)
            {
                float3 _3839 = _3831.xyz * v2f_sh.xyz;
                _5304 = float4(_3839.x, _3839.y, _3839.z, _3831.w);
            }
            else
            {
                _5304 = _3831;
            }
            _5309 = lerp(_5304, _5307, ReflectionProbeInfo.x.xxxx);
        }
        else
        {
            _5309 = _5307;
        }
        _5308 = _5309;
    }
    else
    {
        _5308 = 0.0f.xxxx;
    }
    float4 _3986 = (float4(-1.0f, -0.0274999998509883880615234375f, -0.572000026702880859375f, 0.02199999988079071044921875f) * _2297) + float4(1.0f, 0.0425000004470348358154296875f, 1.03999996185302734375f, -0.039999999105930328369140625f);
    float2 _4006 = (float2(-1.03999996185302734375f, 1.03999996185302734375f) * ((min(_3986.x * _3986.x, exp2((-9.27999973297119140625f) * _2576)) * _3986.x) + _3986.y)) + _3986.zw;
    float3 _2177 = ((_2540 + _5302) + ((v2f_sh.xyz * _2607) * _2470)) + ((((_2602 * _4006.x) + _4006.y.xxx) * _5308.xyz) * _2470);
    _entryPointOutput = float4(_2177 + (max(0.0f.xxx, _2177 + ((_2177 - (0.5f * (max(_2177.x, max(_2177.y, _2177.z)) + min(_2177.x, min(_2177.y, _2177.z)))).xxx) * ColorAdjust.x)) * ColorAdjust.y), (_2219.w * BaseColor.w) * AlphaMtl);

}

STTargets fs_main(STVaring stage_input)
{
    v2f_position_world = stage_input.v2f_position_world;
    v2f_uv = stage_input.v2f_uv;
    v2f_tangent = stage_input.v2f_tangent;
    v2f_binormal = stage_input.v2f_binormal;
    v2f_normal = stage_input.v2f_normal;
    v2f_shadow_pos = stage_input.v2f_shadow_pos;
    v2f_sh = stage_input.v2f_sh;
    frag_main();
    STTargets stage_output;
    stage_output._entryPointOutput = _entryPointOutput;
    // stage_output._entryPointOutput = float4(v2f_normal, 1);
    return stage_output;
}
