// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "nieveShader"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 35
		_snow("snow", 2D) = "white" {}
		_ground("ground", 2D) = "white" {}
		_rt("rt", 2D) = "white" {}
		_altura("altura", Float) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _rt;
		uniform float _altura;
		uniform sampler2D _snow;
		uniform float4 _snow_ST;
		uniform sampler2D _ground;
		uniform float4 _ground_ST;
		uniform float4 _Color0;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float4 tex2DNode3 = tex2Dlod( _rt, float4( ( 1.0 - v.texcoord.xy ), 0, 0.0) );
			v.vertex.xyz += ( ( 1.0 - tex2DNode3.r ) * float3(0,1,0) * _altura );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_snow = i.uv_texcoord * _snow_ST.xy + _snow_ST.zw;
			float2 uv_ground = i.uv_texcoord * _ground_ST.xy + _ground_ST.zw;
			float4 tex2DNode3 = tex2D( _rt, ( 1.0 - i.uv_texcoord ) );
			float4 lerpResult14 = lerp( tex2D( _snow, uv_snow ) , ( tex2D( _ground, uv_ground ) * _Color0 ) , tex2DNode3.r);
			o.Albedo = lerpResult14.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
640;567;939;434;-197.7037;139.7632;2.228524;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;406.5256,449.2792;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;660.9256,450.8792;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;22;695.2635,197.4966;Inherit;False;Property;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.7643734,0.7960573,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;393.4619,176.4306;Inherit;True;Property;_ground;ground;6;0;Create;True;0;0;0;False;0;False;-1;None;70f6b0071d13f1243ad88c815f71136d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;844.4498,423.2089;Inherit;True;Property;_rt;rt;7;0;Create;True;0;0;0;False;0;False;-1;None;3aa5eb07d2e44c34689575b8442fe346;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;928.5435,179.1255;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;18;1200.125,527.6793;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;19;1213.987,679.6793;Inherit;False;Property;_altura;altura;8;0;Create;True;0;0;0;False;0;False;0;0.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;20;1210.438,449.2793;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;837.6699,-21.33402;Inherit;True;Property;_snow;snow;5;0;Create;True;0;0;0;False;0;False;-1;None;70f6b0071d13f1243ad88c815f71136d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;14;1264.896,81.42554;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1472.499,360.9759;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1637.779,85.26296;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;nieveShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;35;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;15;0
WireConnection;3;1;16;0
WireConnection;21;0;2;0
WireConnection;21;1;22;0
WireConnection;20;0;3;1
WireConnection;14;0;1;0
WireConnection;14;1;21;0
WireConnection;14;2;3;1
WireConnection;17;0;20;0
WireConnection;17;1;18;0
WireConnection;17;2;19;0
WireConnection;0;0;14;0
WireConnection;0;11;17;0
ASEEND*/
//CHKSM=08B0B1F434C9EEA89DE41679F1E410B6639134D5