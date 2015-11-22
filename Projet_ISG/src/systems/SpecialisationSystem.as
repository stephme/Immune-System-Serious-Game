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
	import com.lip6.genome.geography.move.component.Speed;
	import components.SpecialisationLevel;
	import components.ToxinProduction;
	import components.VirusTypeV;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class SpecialisationSystem extends System {
		
		public static const RECOGNITION_AREA_RADIUS:Number = 50;
		public static const ACTION_AREA_RADIUS:Number = 70;
		
		private var lymphoBEntities:Family;
		private var bacteriaEntities:Family;
		private var virusEntities:Family;
		private var specialisationLevelMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var layeredMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var speedMapper:IComponentMapper;
		private var virusTypeMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			lymphoBEntities = entityManager.getFamily(allOfGenes(SpecialisationLevel));
			bacteriaEntities = entityManager.getFamily(allOfGenes(ToxinProduction));
			virusEntities = entityManager.getFamily(allOfGenes(VirusTypeV));
			
			// Définition des mappers
			specialisationLevelMapper = geneManager.getComponentMapper(SpecialisationLevel);
			transformMapper = geneManager.getComponentMapper(Transform);
			nodeMapper = geneManager.getComponentMapper(Node);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			layeredMapper = geneManager.getComponentMapper(Layered);
			layerMapper = geneManager.getComponentMapper(Layer);
			speedMapper = geneManager.getComponentMapper(Speed);
			virusTypeMapper = geneManager.getComponentMapper(VirusTypeV);
		}
		
		override protected function onProcess(delta:Number):void {
			var lb:IEntity, b:IEntity, v:IEntity;
			var lbtr:Transform, s:SpecialisationLevel, n:Node, btr:Transform, speed:Speed;
			for (var i:int = 0; i < lymphoBEntities.members.length; i++) {
				lb = lymphoBEntities.members[i];
				lbtr = transformMapper.getComponent(lb);
				s = specialisationLevelMapper.getComponent(lb);
				n = nodeMapper.getComponent(lb);
				if (s.addActionArea)
					addActionArea(s, n, layerMapper.getComponent(lb).id);
				if (s.spec == SpecialisationEnum.NONE) {
					for (var j:int = 0; j < bacteriaEntities.members.length; j++) {
						b = bacteriaEntities.members[j];
						if (Contact.bacteriaContact(lbtr, transformMapper.getComponent(b), RECOGNITION_AREA_RADIUS)) {
							s.bacteriaSpecLevel += SpecialisationLevel.SPE_INCREMENT;
							trace(s.bacteriaSpecLevel);
							if (s.bacteriaSpecLevel == 100) {
								s.spec = SpecialisationEnum.BACTERIA;
								trace("lymphoB is bacteria specialised");
							}
							btr = transformMapper.getComponent(n.outNodes[4].entity);
							btr.scaleX = Number(s.bacteriaSpecLevel) / 100;
						}
					}
					for (j = 0; j < virusEntities.members.length; j++) {
						v = virusEntities.members[j];
						if (Contact.virusContact(lbtr, transformMapper.getComponent(v), RECOGNITION_AREA_RADIUS)) {
							s.virusSpecLevel += SpecialisationLevel.SPE_INCREMENT;
							trace(s.virusSpecLevel);
							if (s.virusSpecLevel == 100) {
								s.spec = SpecialisationEnum.VIRUS;
								trace("lymphoB is virus specialised");
							}
							btr = transformMapper.getComponent(n.outNodes[3].entity);
							btr.scaleX = Number(s.virusSpecLevel) / 100;
						}
					}
					if (s.spec != SpecialisationEnum.NONE)
						removeRecognitionArea(s, n);
				} else if (s.spec == SpecialisationEnum.VIRUS) {
					for (j = 0; j < virusEntities.members.length; j++) {
						v = virusEntities.members[j];
						if (Contact.virusContact(lbtr, transformMapper.getComponent(v), ACTION_AREA_RADIUS)) {
							speed = speedMapper.getComponent(v);
							var vt:VirusTypeV = virusTypeMapper.getComponent(v);
							if (speed.velocity == EntityFactory.MED_SPEED && vt.effectiveness > 0) {
								// Le virus est agglutine
								speed.velocity = EntityFactory.LOW_SPEED;
								vt.effectiveness = 0;
							}
						}
					}
				} else {
					for (j = 0; j < bacteriaEntities.members.length; j++) {
						b = bacteriaEntities.members[j];
						if (Contact.bacteriaContact(lbtr, transformMapper.getComponent(b), ACTION_AREA_RADIUS)) {
							speed = speedMapper.getComponent(b);
							if (speed.velocity == EntityFactory.MED_SPEED)
								speed.velocity = EntityFactory.LOW_SPEED;
						}
					}
				}
			}
		}
		
		private function removeRecognitionArea(s:SpecialisationLevel,n:Node):void {
			var e:IEntity = n.outNodes[2].entity;
			entityManager.removeComponent(e, textureResourceMapper.gene);
			entityManager.removeComponent(e, layeredMapper.gene);
			entityManager.removeComponent(e, transformMapper.gene);
			s.addActionArea = true;
		}
		
		private function addActionArea(s:SpecialisationLevel,n:Node,id:String):void {
			var e:IEntity = n.outNodes[2].entity;
			entityManager.addComponent(e, TextureResource, { source: "pictures/actionArea.png", id : "actionArea" } );
			entityManager.addComponent(e, Layered, { layerId: id } );
			entityManager.addComponent(e, Transform, { x:-ACTION_AREA_RADIUS, y:-ACTION_AREA_RADIUS, scaleX: ACTION_AREA_RADIUS / 50, scaleY: ACTION_AREA_RADIUS / 50, alpha: 0.2} );
			s.addActionArea = false;
		}
		
	}

}