float ColorGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 0.1;
	float vd_tunablemax = 10.0f;
> = 1.0f;

float Saturation <
	bool vd_tunable = true;
	float vd_tunablemin = 1.00;
	float vd_tunablemax = -3.0f;
> = 0.0f;

float EffectGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 3.0;
	float vd_tunablemax = 0.01f;
> = 1.0f;

float Gamma <
	bool vd_tunable = true;
	float vd_tunablemin = 3.0;
	float vd_tunablemax = 0.01f;
> = 1.0f;

float Amount <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = -1.0f;
> = 1.0f;


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

	A = 1 - A;

	A = pow(A, EffectGamma);

	if (A < 0.5)

		C = (2 * A - 1) * (B - B * B) + B;

	else

		C = (2 * A - 1) * (sqrt(B) - B) + B;

	float4 value = max(max(C.r, C.g), C.b);
	float4 color = C / value;

	color = pow(color, 1/ColorGamma);

	C = color * value;

	float3x3 m = {
			-1, 0.5, 0.5,
			0.5, -1, 0.5,
			0.5, 0.5, -1
			};
	C.rgb += mul(C.rgb, m) * Saturation;

	if (C.r < 0.0)
		C.r = 0.0;

	if (C.g < 0.0)
		C.g = 0.0;

	if (C.b < 0.0)
		C.b = 0.0;

	C = pow(C, Gamma);

	C = lerp(C, B, Amount);

	return C;
}

technique {
	pass {
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS();
	}
}
