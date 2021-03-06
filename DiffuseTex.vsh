/**
 * @file DiffuseTex.psh
 * Desert Racer vertex shader
 *
 * @author Laurent Noel, Probably
 * @author Jacob Sanchez Perez (G20812080) <jsanchez-perez@uclan.ac.uk>
 * Games Concepts (CO1301), University of Central Lancashire
 */

//-----------------------------------------------------------------------------
// Global variables
//-----------------------------------------------------------------------------

// World matrix and combined view / projection matrix
float4x3 WorldMatrix    : WORLD;
float4x4 ViewProjMatrix : VIEWPROJECTION;
float3 CameraPosition   : CAMERAPOSITION;



//-----------------------------------------------------------------------------
// Input / output structures
//-----------------------------------------------------------------------------

// Input to Vertex Shader
struct VS_Input
{
	float3 Position : POSITION;
	float3 Normal : NORMAL;
	float2 TexCoord0 : TEXCOORD0;
};

// Output from Vertex Shader
struct VS_Output
{
	float4 Position : POSITION;
	float3 DiffuseColour : COLOR0;
	float3 SpecularColour : COLOR1;
	float2 TexCoord0 : TEXCOORD0;
};

//-----------------------------------------------------------------------------
// Main function
//-----------------------------------------------------------------------------

// Main vertex shader function
void main( in VS_Input i, out VS_Output o )
{
	// Can change colour + intensity of light
	const float3 AmbientColour = { 0.3f, 0.3f, 0.3f };
	const float3 LightColour = { 1.0f, 1.0f, 1.0f };

	// Probably changes position of light source + intensity
	const float3 DirToLight = { 0.408f, 0.408f, -0.816 };

	// The lower the brighter
	const float SpecularPower = 30.0f;

    // Transform model vertex position to world space, then to viewport space, then output it
	float4 newPosition = float4(i.Position, 1.0f);
    float3 WorldPosition = mul( newPosition, WorldMatrix );

    o.Position = mul( float4(WorldPosition, 1.0f), ViewProjMatrix );

	// Calculate normal (?)
	float3 Normal = normalize( mul( float4(i.Normal, 0.0f), WorldMatrix ) ).xyz;

	// Usually calculates diffuse colour
	float3 DiffuseColour = AmbientColour + LightColour * saturate( dot( Normal, DirToLight ) );

	float3 DirToCamera = normalize( CameraPosition - WorldPosition );
	float3 H = normalize( DirToCamera + DirToLight );
	float3 SpecularColour = LightColour * pow( saturate( dot(Normal, H) ), SpecularPower ); // Phong

	o.DiffuseColour = DiffuseColour;
	o.SpecularColour = SpecularColour;
	o.TexCoord0 = i.TexCoord0;
}
