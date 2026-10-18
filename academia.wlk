class Cosa{
	//algo a guardar
	const property marca
	const property volumen
	const property magico
	const property reliquia   
}

class Mueble{
	//guarda cosas, es el TIPO, ergo, clase abstracta
	const property cosas = []
	method puedeGuardar(cosa)
	method validarGuardar(cosa){
		//Si no puede guardar, tira error
		if (! self.puedeGuardar(cosa)) {(self.error("No se puede guardar"))}
	}
	method validarExiste(cosa){
		if (cosas.contains(cosa)) {(self.error("No se puede guardar porque ya está guardado"))}
	}
	method guardar(cosa){
		self.validarExiste(cosa)
		self.validarGuardar(cosa)
		cosas.add(cosa)

	}
}

class ArmarioConvencional inherits Mueble{
	const property cantidadMax 

	override method puedeGuardar(cosa){
		//retorna si puede o no guardar cosa
		return (cosas.size() + 1) <= cantidadMax 
	}
}
class GabineteMagico inherits Mueble{

	override method puedeGuardar(cosa){
		//retorna si puede o no guardar cosa
		return cosa.magico()
	}
}
class Baul inherits Mueble{
	const property capacidadMax
	
	method volumenUsado(){
		return cosas.sum({ cosa => cosa.volumen()})
	}

	override method puedeGuardar(cosa){
		//retorna si puede o no guardar cosa
		return (cosa.volumen()+ self.volumenUsado()) <= capacidadMax
	}

	
}


object academiaDeMagia {}