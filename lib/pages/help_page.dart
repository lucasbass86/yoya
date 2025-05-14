import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';
import 'package:yoya/widgets/_widgets.dart';

class HelpPage extends StatelessWidget {
  static const String routeName = 'HelpPage';
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int delay = 200;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TopWidget(title: 'Ayuda', showExit: true),
                const SizedBox(height: 20),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          FadeInLeft(
                            delay: Duration(milliseconds: delay * 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ExpansionTile(
                                iconColor: Utils.lightColorBackground,
                                collapsedIconColor: Utils.darkColorBackground,
                                backgroundColor: Utils.darkColorSecond,
                                collapsedBackgroundColor: Utils.darkColorSecond,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Text('Inicio', style: Utils.bigTitleStyle),
                                childrenPadding: const EdgeInsets.all(10),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  const SizedBox(height: 10),
                                  Text('''En la ventana principal encontramos todos los registros creados con anterioridad.
Desde la lupa situada en la parte superior izquierda podremos buscar entre los registros.
Podremos dar de alta un registro haciendo tap en el icono inferior derecho.
Haciendo tap en el registro, accedemos al detalle.
Cuando se pulsa sobre el icono correspondiente al perfil deseado, se incrementa dicho contador. Se puede disminuir el contador al hacer tap en el número.
Si se mantiene pulsado el icono, se mostrará la ventana de detalle de dicho perfil.

En la parte superior podemos:
- Ver todos los perfiles creados.
- Configuración.''', textAlign: TextAlign.justify),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInLeft(
                            delay: Duration(milliseconds: delay * 2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ExpansionTile(
                                iconColor: Utils.lightColorBackground,
                                collapsedIconColor: Utils.darkColorBackground,
                                backgroundColor: Utils.darkColorSecond,
                                collapsedBackgroundColor: Utils.darkColorSecond,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Text('Registro', style: Utils.bigTitleStyle),
                                childrenPadding: const EdgeInsets.all(10),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  const SizedBox(height: 10),
                                  Text('''En este apartado se muestra toda la información del registro.
Con el icono de la papelera, se permite borrar el registro.
Se indica la descripción, observaciones y los perfiles que contiene este registro.
Se puede incrementar y decrementar los contadores de cada perfil. Los cambios se realizan en el acto (no hace falta guardar desde el icono).
Se muestra los porcentajes de cada perfil en dicho registro.

Se indican todos los movimientos del registro.
Haciendo tap en la lupa, se filtrará por el contenido escrito.

Manteniendo pulsado un histórico se puede editar la fecha.

Pulsando el icono situado en la parte inferior derecha, modificará el registro actual.
Los perfiles no se pueden cambiar. Únicamente las descripciones.''', textAlign: TextAlign.justify),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInLeft(
                            delay: Duration(milliseconds: delay * 3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ExpansionTile(
                                iconColor: Utils.lightColorBackground,
                                collapsedIconColor: Utils.darkColorBackground,
                                backgroundColor: Utils.darkColorSecond,
                                collapsedBackgroundColor: Utils.darkColorSecond,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Text('Perfiles', style: Utils.bigTitleStyle),
                                childrenPadding: const EdgeInsets.all(10),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  const SizedBox(height: 10),
                                  Text('''Esta ventana mostrará todos los perfiles dados de alta.
Se puede crear uno desde el icono inferior derecho, indicando el nombre e icono del perfil nuevo.
Con el icono de la lupa, se puede filtrar.

Pulsando en un perfil accedemos al detalle de este.
Se mostrará una lista con todos los registros en lo que aparece dicho perfil. Con opción de filtrar.
Haciendo tap en el registro se va al detalle de este.

Se puede borrar dicho perfil haciendo tap en el icono de la papelera (en la posición superior derecha).
Si se borra el perfil, se borrarán todos los registros relacionados (tanto registros como historial).
Del perfil se pueden modificar el nombre y el icono, guardando los datos desde el icono situado en la parte inferior derecha.''', textAlign: TextAlign.justify),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInLeft(
                            delay: Duration(milliseconds: delay * 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ExpansionTile(
                                iconColor: Utils.lightColorBackground,
                                collapsedIconColor: Utils.darkColorBackground,
                                backgroundColor: Utils.darkColorSecond,
                                collapsedBackgroundColor: Utils.darkColorSecond,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Text('Configuración', style: Utils.bigTitleStyle),
                                childrenPadding: const EdgeInsets.all(10),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  const SizedBox(height: 10),
                                  Text('''La ventana de Configuración ofrece la posibilidad de hacer una copia de datos en la nube.
Antes de realizar la primera copia, por más seguridad se preguntará una contraseña, para posteriores restauraciones de datos.

También ofrece la posibilidad de exportar a un archivo los datos.

Si se borra el correo, se borrarán los datos existentes en la nube.''', textAlign: TextAlign.justify),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
