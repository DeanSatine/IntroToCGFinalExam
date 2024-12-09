Shader "Custom/DeanChromeShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Distortion("Distortion", Range(-1, 1)) = 0.1
        _Scale("Scale", Range(0, 10)) = 1
        _Center("Center", Vector) = (0.5, 0.5, 0, 0)
        _OffsetR("OffsetR", Range(-0.01, 0.01)) = 0.001
        _OffsetG("OffsetG", Range(-0.01, 0.01)) = 0.001
        _OffsetB("OffsetB", Range(-0.01, 0.01)) = -0.001
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _Distortion;
            float _Scale;
            float4 _Center;
            float _OffsetR;
            float _OffsetG;
            float _OffsetB;
            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 center = _Center.xy;
                float2 p = i.uv - center;
                float r2 = dot(p, p);
                float2 distortion = p * (_Distortion * r2 + 1);
                float2 uv = center + distortion * _Scale;
                float2 offsetR = float2(_OffsetR, 0);
                float2 offsetG = float2(_OffsetG, 0);
                float2 offsetB = float2(_OffsetB, 0);
                float4 texR = tex2D(_MainTex, uv + offsetR);
                float4 texG = tex2D(_MainTex, uv + offsetG);
                float4 texB = tex2D(_MainTex, uv + offsetB);
                float3 color = float3(texR.r, texG.g, texB.b);
                color *= 1.5;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
