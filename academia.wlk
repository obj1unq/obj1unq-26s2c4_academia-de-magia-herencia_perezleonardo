
class Cosa{
	//algo a guardar
	const property marca
	const property volumen
	const property magica
	const property reliquia

	method aporteMagica(){
		if (magica) {return 3} 
		else { return 0}
	}
	method aporteReliquia(){
		if (reliquia) {return 5} 
		else { return 0}}

	method utilidad(){
		return volumen + self.aporteMagica() + self.aporteReliquia() + marca.aporte(self) 
 
	}    
}

//WKO
object acme {
    method aporte(cosa) = cosa.volumen() / 2
}
object fenix {
    method aporte(cosa) = if (cosa.reliquia()) 3 else 0
}
object cuchuflito {
    method aporte(cosa) = 0
}


class Mueble{
	//guarda objetos del tipo Cosa
	// es una clase abstracta
	const property cosas = []

	method precio()

 	method utilidad(){
		return cosas.sum({cosa => cosa.utilidad()}) / self.precio()
	}
	method estaGuardada(cosa){
		return cosas.contains(cosa) 
	}
	method admite(cosa)
	method validarAdmitir(cosa){
		//Si no puede guardar, tira error
		if (! self.admite(cosa)) {self.error("No se admite este objeto")}
	}

	method validarGuardada(cosa){
		//Si no está guardada, tira error 
		if (! self.estaGuardada(cosa)) {self.error("No se puede eliminar porque no está guardado")}
	}


	method validarNoGuardada(cosa){
		//Si ya está guardada, tira error 
		if (self.estaGuardada(cosa)) {self.error("No se puede guardar porque ya está guardado")}
	}
	method validarGuardar(cosa){
		self.validarNoGuardada(cosa)
		self.validarAdmitir(cosa)
	}
	method guardar(cosa){
		self.validarGuardar(cosa)
		cosas.add(cosa)
	}

	method remover(cosa){
		self.validarGuardada(cosa) 
		cosas.remove(cosa)
	}

	method elementoMenosUtil(){
		return cosas.min({cosa => cosa.utilidad()})
	}

}

class ArmarioConvencional inherits Mueble{
	var property cantidadMax 

	override method admite(cosa){
		//retorna si puede o no guardar cosa
		return (cosas.size() + 1) <= cantidadMax 
	}

	override method precio(){
		return cantidadMax * 5
	}
}
class GabineteMagico inherits Mueble{
	const property precio 
	override method admite(cosa){
		//retorna si puede o no guardar cosa
		return cosa.magica()
	}


}
class Baul inherits Mueble{
	const property volumenMax
	
	method volumenUsado(){
		return cosas.sum({ cosa => cosa.volumen()})
	}

	override method admite(cosa){
		//retorna si puede o no guardar cosa
		return (cosa.volumen()+ self.volumenUsado()) <= volumenMax
	}

	override method precio(){
		return volumenMax + 2
	}

	method todasReliquias(){
		return cosas.all({cosa => cosa.reliquia()})
	}

	method extraPorReliquias(){
		if (self.todasReliquias()) {return 2} 
		else { return 0}
	}

	override method utilidad(){
		return super() + self.extraPorReliquias()
	}

	
}

class BaulMagico inherits Baul {
		override method utilidad(){
		return super() + self.cantidadMagicas()	
	}

	method cantidadMagicas(){
		return cosas.count({cosa => cosa.magica()})
	}

	override method precio(){
		return super() * 2
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
	method elementosMenosUtiles(){
		return muebles.map({mueble => mueble.elementoMenosUtil()})
	}

	method marcaDelMenosUtil(){
		return self.elementosMenosUtiles().min({ elemento => elemento.utilidad()}).marca()
	}

	method elementosMenosUtilesNoMagicos(){
		return self.elementosMenosUtiles().filter({elemento => ! elemento.magica()})
	}

	method validarCantidadDeMuebles(){
		if (muebles.size() < 3) {self.error("No se puede eliminar porque tiene menos de 3 muebles")}
	}

	method remover(elemento){
		self.buscar(elemento).remover(elemento)
	}

	method removerMenosUtiles(){
		self.validarCantidadDeMuebles() //chequeamos que existen 3 muebles en la academia
		self.elementosMenosUtilesNoMagicos().forEach({elemento => self.remover(elemento)})
		
	}

	method quitarMueble(mueble){
		//No uso validar porque esto lo vamos a usar solo para el test, ergo, esta validado
		muebles.remove(mueble)
	}
}