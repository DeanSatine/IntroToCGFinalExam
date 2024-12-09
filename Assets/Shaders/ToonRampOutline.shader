Shader "Custom/DeanToomRampOutlineShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _Outline("Outline Width", Range(0.05, 1)) = 0.005
    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;

        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float lightIntensity = (dot(s.Normal, lightDir) * 0.5 + 0.5) * atten;
            float rampInput = lightIntensity * 0.5 + 0.5;
            float3 rampColor = tex2D(_RampTex, float2(rampInput, 0)).rgb;

            float4 result;
            result.rgb = s.Albedo * _LightColor0.rgb * rampColor;
            result.a = s.Alpha;
            return result;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_RampTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 mainTexture = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = mainTexture.rgb;
            o.Alpha = mainTexture.a;
        }
        ENDCG

        Pass
        {
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            float _Outline;
            float4 _OutlineColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 worldNormal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float2 outlineOffset = TransformViewToProjection(worldNormal.xy);

                o.pos.xy += outlineOffset * o.pos.z * _Outline;
                o.color = _OutlineColor;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
