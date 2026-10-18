
class Cosa{
	//algo a guardar
	const property marca
	const property volumen
	const property magica
	const property reliquia   
}

class Mueble{
	//guarda objetos del tipo Cosa
	const property cosas = []

	method estaGuardada(cosa){
		return cosas.contains(cosa) //este metodo puede ser redundante, pero con los test se reutiliza
	}
	method admite(cosa)
	method validarAdmitir(cosa){
		//Si no puede guardar, tira error
		if (! self.admite(cosa)) {(self.error("No se admite este objeto"))}
	}
	method validarNoGuardada(cosa){
		//Si ya está guardada, tira error 
		if (self.estaGuardada(cosa)) {(self.error("No se puede guardar porque ya está guardado"))}
	}
	method validarGuardar(cosa){
		self.validarNoGuardada(cosa)
		self.validarAdmitir(cosa)
	}
	method guardar(cosa){
		self.validarGuardar(cosa)
		cosas.add(cosa)
	}
}

class ArmarioConvencional inherits Mueble{
	var property cantidadMax 

	override method admite(cosa){
		//retorna si puede o no guardar cosa
		return (cosas.size() + 1) <= cantidadMax 
	}
}
class GabineteMagico inherits Mueble{

	override method admite(cosa){
		//retorna si puede o no guardar cosa
		return cosa.magica()
	}
}
class Baul inherits Mueble{
	const property capacidadMax
	
	method volumenUsado(){
		return cosas.sum({ cosa => cosa.volumen()})
	}

	override method admite(cosa){
		//retorna si puede o no guardar cosa
		return (cosa.volumen()+ self.volumenUsado()) <= capacidadMax
	}

	
}


class Academia{
	const property muebles = []

	method estaGuardada(cosa){
		return muebles.any({ mueble => mueble.estaGuardada(cosa) })
	}
	method buscar(cosa){
		return muebles.find({mueble => mueble.estaGuardada(cosa)})
	}

	method algunMuebleAdmite(cosa){
		return ! self.mueblesQueAdmiten(cosa).isEmpty()
	}
	method sePuedeGuardar(cosa) {
    	return (!self.estaGuardada(cosa)) &&  self.algunMuebleAdmite(cosa)
		}
	method mueblesQueAdmiten(cosa){
		return muebles.filter({mueble => mueble.admite(cosa)})
	}
	method validarSePuedeGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){self.error("No se puede guardar")}
	}
	method guardar(cosa) {
    self.validarSePuedeGuardar(cosa)
    self.mueblesQueAdmiten(cosa).first().guardar(cosa)
}
}