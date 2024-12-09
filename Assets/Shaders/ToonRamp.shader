Shader "Custom/DeanShaderToonRamp"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _myBump("Bump Texture", 2D) = "bump" {}
        _mySlider("Bump Amount", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonRamp
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;
        fixed4 _Color;
        sampler2D _myBump;
        half _mySlider;

        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = (dot(s.Normal, lightDir) * 0.5 + 0.5) * atten;
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 t;
            t.rgb = s.Albedo * _LightColor0.rgb * ramp;
            t.a = s.Alpha;
            return t;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_RampTex;
            float2 uv_myBump;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));
            o.Normal *= float3(_mySlider, _mySlider, 1);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
