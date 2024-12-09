Shader "Custom/DeanWarnaBaseShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
        _RimColor("Rim Color", Color) = (0, 0.5, 0.5, 0)
        _RimPower("Rim Power", Range(0.5, 8.0)) = 3.0

    }

    SubShader
    {
        CGPROGRAM

        #include "UnityCG.cginc"

        #pragma surface surf ToonRamp

        sampler2D _MainTex;
        sampler2D _RampTex;
        float4 _RimColor;
        float _RimPower;


        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rampCoord = h;
            float3 ramp = tex2D(_RampTex, rampCoord).rgb;

            float4 result;
            result.rgb = s.Albedo * _LightColor0.rgb * ramp;
            result.a = s.Alpha;
            return result;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_RampTex;
            //float2 uv_myBump;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 colorSample = tex2D(_MainTex, IN.uv_MainTex);
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Albedo = colorSample.rgb - _RimColor.rgb * pow(rim, _RimPower) * 3;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
