texture vd_srctexture;
float4 vd_texsize;

sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = None;
};

void VS(
	float4 pos : POSITION,
	float2 t0 : TEXCOORD0,
	out float4 oPos : POSITION,
	out float2 oT0 : TEXCOORD0
)
{
	oPos = pos;
	oT0 = t0;
}

float4 PS(float2 uv : TEXCOORD0) : COLOR0 {
   float4 B = tex2D(src, uv);
   float A = dot(float3(1.0/3.0, 1.0/3.0, 1.0/3.0), B.rgb);
   float4 C;


	if (A < 0.5)

		C = (2 * A - 1) * (B - B * B) + B;

	else

		C = (2 * A - 1) * (sqrt(B) - B) + B;

	return C;
}

technique {
	pass {
		VertexShader = compile vs_2_a VS();
		PixelShader = compile ps_2_a PS();
	}
}
