package
{
	public class AssetsParticles
	{
		[Embed(source="../media/particles/explosion.pex", mimeType="application/octet-stream")]
		public static var ParticleXML:Class;
		
		[Embed(source="../media/particles/explosionTexture.png")]
		public static var ParticleTexture:Class;
		
		[Embed(source="../media/particles/heroDead.pex", mimeType="application/octet-stream")]
		public static var HeroDeadXML:Class;
		
		[Embed(source="../media/particles/HeroTexture.png")]
		public static var ParticleTextureHero:Class;
	}
}