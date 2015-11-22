package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.impl.Entity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.resource.component.TextureResource;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Layer;
	import components.DeathCertificate;
	import components.HolderInfection;
	import components.Health;
	import components.SpecialisationLevel;
	import components.ToxinProduction;
	import components.VirusTypeA;
	import components.VirusTypeV;

	/**
	 * ...
	 * @author Stéphane
	 */
	public class VirusInfectionSystem extends System {
		
		private var virusEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var virusTypeVMapper:IComponentMapper;
		private var virusTypeAMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var layeredMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var holderMapper:IComponentMapper;
	
		override protected function onConstructed():void {
			virusEntities = entityManager.getFamily(allOfGenes(VirusTypeV));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction))); // bactery
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.MACRO))); // macrophage

			transformMapper = geneManager.getComponentMapper(Transform);
			virusTypeVMapper = geneManager.getComponentMapper(VirusTypeV);
			virusTypeAMapper = geneManager.getComponentMapper(VirusTypeA);
			healthMapper = geneManager.getComponentMapper(Health);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			nodeMapper = geneManager.getComponentMapper(Node);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			layeredMapper = geneManager.getComponentMapper(Layered);
			layerMapper = geneManager.getComponentMapper(Layer);
			holderMapper = geneManager.getComponentMapper(HolderInfection);
		}

		override protected function onProcess(delta:Number):void {
			var victimsVector:Vector.<IEntity> = new Vector.<IEntity>;
			for (var j:int = 0; j <  victimFamilies.length;  ++j) {
				victimsVector = victimsVector.concat(victimFamilies[j].members);
			}
			for (var i:int = 0; i < victimsVector.length; i++) {
				var victim:IEntity = victimsVector[i];
				var victimVt:VirusTypeA = virusTypeAMapper.getComponent(victim);
				if (victimVt != null) {
					var victimHi:HolderInfection = holderMapper.getComponent(victim);
					if (victimHi != null && !victimVt.swapImg) {
						var er:IEntity = nodeMapper.getComponent(victim).outNodes[1].entity;
						entityManager.addComponent(er, Transform, {x: victimHi.x, y: victimHi.y})
						entityManager.addComponent(er, TextureResource, { source: "pictures/" + victimHi.idImg + "_infected.png", id : victimHi.idImg + "_infected" } );
						entityManager.addComponent(er, Layered, { layerId: layerMapper.getComponent(victim).id } );
						entityManager.removeComponent(victim, holderMapper.gene);						
					}
					continue;
				}
				var victimTr:Transform = transformMapper.getComponent(victim);
				var victimH:Health = healthMapper.getComponent(victim);
				for (var h:int = 0; h < virusEntities.members.length; h++) {
					var virus:IEntity = virusEntities.members[h];
					var virusDc:DeathCertificate = deathCertificateMapper.getComponent(virus);
					var virusVt:VirusTypeV = virusTypeVMapper.getComponent(virus);
					var virusTr:Transform = transformMapper.getComponent(virus);
					if (Contact.virusContact(victimTr, virusTr, 25)) {
						trace("entity is infected by a virus");
						var _e:IEntity = nodeMapper.getComponent(victim).outNodes[1].entity;
						var id:String = textureResourceMapper.getComponent(_e).id;
						entityManager.addComponent(victim, VirusTypeA, {
							propagation : virusVt.propagation,
							effectiveness : virusVt.effectiveness
						});
						entityManager.addComponent(victim, HolderInfection, {
							idImg : textureResourceMapper.getComponent(_e).id,
							x : transformMapper.getComponent(_e).x,
							y : transformMapper.getComponent(_e).y
						});
						entityManager.removeComponent(_e, textureResourceMapper.gene);
						entityManager.removeComponent(_e, layeredMapper.gene);
						entityManager.removeComponent(_e, transformMapper.gene);
						
						trace("virus is killed");
						virusDc.dead = true;
					}
				}
			}
		}
	}
}

/*						if (textureRes != null) {
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
						}*/
