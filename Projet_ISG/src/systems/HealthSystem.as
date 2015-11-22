package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.DeathCertificate;
	import components.Health;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class HealthSystem extends System {
		
		private var entities:Family;
		private var nodeMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var layeredMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			entities = entityManager.getFamily(allOfGenes(Health,DeathCertificate));
			
			nodeMapper = geneManager.getComponentMapper(Node);
			healthMapper = geneManager.getComponentMapper(Health);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			layeredMapper = geneManager.getComponentMapper(Layered);
			layerMapper = geneManager.getComponentMapper(Layer);
			transformMapper = geneManager.getComponentMapper(Transform);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0; i < entities.members.length; i++) {
				var e:IEntity = entities.members[i];
				var h:Health = healthMapper.getComponent(e);
				var n:Node = nodeMapper.getComponent(e);
				var deathCerti:DeathCertificate = deathCertificateMapper.getComponent(e);
				if (h.currentPV <= 0)
					deathCerti.dead = true;
				else if (deathCerti.infected > 0) {
					if (++h.cpt == h.freq) {
						updateHealth(n, h);
						if (Math.random() < 0.5)
							deathCerti.infected += h.numVirusIncrement;
						h.cpt = 0;
					}
				}
				else if (h.lifeDecrement > 0 && deathCerti.infected == 0) {
					var _e:IEntity = n.outNodes[1].entity;
					var textureRes:TextureResource = textureResourceMapper.getComponent(_e);
					if (textureRes != null) {
						h.id = textureRes.id;
						entityManager.removeComponent(_e, textureResourceMapper.gene);
						entityManager.removeComponent(_e, layeredMapper.gene);
						//entityManager.removeComponent(_e, transformMapper.gene);
					} else {
						//entityManager.addComponent(_e, Transform, { x : -25, y : -25} );
						entityManager.addComponent(_e, TextureResource, { source: "pictures/" + h.id + "_infected.png", id : h.id + "_infected" } );
						entityManager.addComponent(_e, Layered, { layerId: layerMapper.getComponent(e).id } );
						updateHealth(n, h);
						deathCerti.infected += h.numVirusIncrement;
					}
				}
			}
		}
		
		private function updateHealth(n:Node, h:Health):void {
			h.currentPV -= h.lifeDecrement;
			var healthBar:IEntity = n.outNodes[0].entity;
			var htr:Transform = transformMapper.getComponent(healthBar);
			htr.scaleX = Number(h.currentPV) / 100;
		}
		
	}

}