// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get message0001 => 'No se pudo leer el almacenamiento protegido del perfil.';

  @override
  String get message0002 => 'El almacenamiento del perfil no está disponible. Los cambios no se guardaron; se conservaron los datos existentes.';

  @override
  String get message0003 => 'Una clave API no puede combinarse con la autenticación Basic del proxy inverso: ambas usan el encabezado Authorization.';

  @override
  String get message0004 => 'Se rechazó el inicio de sesión. Revisa tus datos de acceso y vuelve a conectarte al servidor.';

  @override
  String get message0005 => 'Selecciona un servidor';

  @override
  String get message0006 => 'El archivo seleccionado no es un .torrent válido. No se enviaron datos.';

  @override
  String get message0007 => 'La operación falló. Revisa la conexión y la configuración del servidor.';

  @override
  String get message0008 => 'El nombre de usuario de HTTP Basic no puede contener dos puntos.';

  @override
  String get message0009 => 'Usa una clave API o credenciales HTTP Basic, no ambas.';

  @override
  String get message0010 => 'La clave API contiene espacios, saltos de línea u otros caracteres no admitidos.';

  @override
  String get message0011 => 'Proporciona el certificado de cliente y su clave privada.';

  @override
  String get message0012 => 'No se pudo cargar la CA personalizada o el certificado de cliente.';

  @override
  String get message0013 => 'Usa una URL de servidor HTTP o HTTPS sin credenciales, consulta ni fragmento incrustados.';

  @override
  String get message0014 => 'Punto de conexión de API no válido.';

  @override
  String get message0015 => 'La conexión con el servidor está cerrada.';

  @override
  String get message0016 => 'El servidor no respondió a la comprobación de la clave API. Revisa la URL del servidor y la configuración de acceso a WebUI.';

  @override
  String get message0017 => 'Error al iniciar sesión. Revisa las credenciales del servidor y la configuración de acceso a WebUI.';

  @override
  String get message0018 => 'El servidor rechazó la clave API. Revisa la clave y la configuración de acceso a WebUI, y luego vuelve a conectarte.';

  @override
  String get message0019 => 'Se rechazó el inicio de sesión. Revisa las credenciales del servidor y la configuración de acceso a WebUI, y luego vuelve a conectarte.';

  @override
  String get message0020 => 'Inicia sesión primero en el servidor.';

  @override
  String get message0021 => 'El servidor devolvió JSON no válido.';

  @override
  String get message0022 => 'El servidor no pudo completar la acción.';

  @override
  String get message0023 => 'El servidor devolvió una lista de torrents no válida.';

  @override
  String get message0024 => 'Selecciona primero torrents válidos.';

  @override
  String get message0025 => 'Introduce una URL de torrent o un enlace magnet.';

  @override
  String get message0026 => 'Elige un archivo de torrent no vacío.';

  @override
  String get message0027 => 'Elige un archivo de torrent con nombre.';

  @override
  String get message0028 => 'Campo de opción de torrent no válido.';

  @override
  String get message0029 => 'El servidor rechazó el archivo de torrent.';

  @override
  String get message0030 => 'El servidor devolvió detalles de torrent no válidos.';

  @override
  String get message0031 => 'Se agotó el tiempo de espera de la solicitud al servidor.';

  @override
  String get message0032 => 'El servidor devolvió una redirección no válida.';

  @override
  String get message0033 => 'El servidor devolvió demasiadas redirecciones.';

  @override
  String message0034(String arg1) {
    return 'El servidor rechazó la solicitud (HTTP $arg1).';
  }

  @override
  String get message0035 => 'La respuesta del servidor es demasiado grande.';

  @override
  String get message0036 => 'No se puede acceder al servidor. Revisa su dirección y la conexión.';

  @override
  String get message0037 => 'Falló la conexión con el servidor.';

  @override
  String get message0038 => 'El servidor devolvió una respuesta no válida.';

  @override
  String get message0039 => 'Falló la solicitud al servidor.';

  @override
  String get message0040 => 'La sesión expiró. Inicia sesión de nuevo.';

  @override
  String get message0041 => 'El servidor rechazó la solicitud (HTTP 403).';

  @override
  String get message0042 => 'Error en la operación';

  @override
  String get message0043 => 'Cancelar';

  @override
  String get message0044 => 'Aplicar';

  @override
  String get message0045 => 'Herramientas del servidor';

  @override
  String get message0046 => 'Sin servidor';

  @override
  String get message0047 => 'Conexión directa a tu qBittorrent. Sin anuncios ni analíticas.';

  @override
  String get message0048 => 'Búsqueda de torrents';

  @override
  String get message0049 => 'Complementos de búsqueda de tu servidor';

  @override
  String get message0050 => 'RSS y reglas de descarga';

  @override
  String get message0051 => 'Feeds, artículos y reglas automáticas';

  @override
  String get message0052 => 'Velocidad y modo de límites';

  @override
  String get message0053 => 'Límites de descarga y subida en KiB/s';

  @override
  String get message0054 => 'Ajustes de qBittorrent';

  @override
  String get message0055 => 'Todas las opciones disponibles de la API de WebUI';

  @override
  String get message0056 => 'Categorías y etiquetas';

  @override
  String get message0057 => 'Crear, editar y eliminar';

  @override
  String get message0058 => 'Registro del servidor';

  @override
  String get message0059 => 'Registro principal y pares bloqueados';

  @override
  String get message0060 => 'Estado de la conexión';

  @override
  String get message0061 => 'Velocidades, datos transferidos y DHT';

  @override
  String get message0062 => 'Paquete mágico en tu red local';

  @override
  String get message0063 => 'Límites de velocidad';

  @override
  String get message0064 => 'Descarga, KiB/s (0 = sin límite)';

  @override
  String get message0065 => 'Subida, KiB/s (0 = sin límite)';

  @override
  String get message0066 => 'Modo alternativo (true/false)';

  @override
  String get message0067 => 'Límites guardados';

  @override
  String get message0068 => 'Dirección MAC';

  @override
  String get message0069 => 'Dirección de difusión';

  @override
  String get message0070 => 'Puerto';

  @override
  String get message0071 => 'Paquete mágico enviado';

  @override
  String get message0072 => 'Ajuste no disponible. Revisa los permisos del dispositivo y la protección de seguridad.';

  @override
  String get message0073 => 'Ajustes del dispositivo';

  @override
  String get message0074 => 'Bloqueo de la app';

  @override
  String get message0075 => 'Autenticación del sistema al abrir la app y al volver a ella.';

  @override
  String get message0076 => 'Notificaciones de finalización';

  @override
  String get message0077 => 'Comprueba mientras la app está abierta. La app debe estar en ejecución para recibir notificaciones.';

  @override
  String get message0078 => 'Consulta directa a qBittorrent. La ejecución en segundo plano está limitada por el sistema operativo; no se garantiza la entrega instantánea.';

  @override
  String get message0079 => 'Intervalo de comprobación en segundo plano';

  @override
  String message0080(String arg1) {
    return '$arg1 min. El sistema operativo puede retrasar el inicio.';
  }

  @override
  String get message0081 => 'Intervalo, en minutos';

  @override
  String get message0082 => 'De 15 a 1440 minutos';

  @override
  String get message0083 => 'Guardar';

  @override
  String get message0084 => 'Sin anuncios ni analítica';

  @override
  String get message0085 => 'No se usan Firebase, SDK de anuncios, configuración remota ni registro de desarrollador. Los perfiles y certificados se guardan en el almacenamiento seguro del sistema operativo.';

  @override
  String get message0086 => 'Conexiones de red';

  @override
  String get message0087 => 'El cliente se conecta a los servidores de qBittorrent que indiques. Wake-on-LAN envía un paquete a la dirección local que introduzcas. La búsqueda y RSS los gestiona tu servidor.';

  @override
  String get message0088 => 'Seguridad de la conexión';

  @override
  String get message0089 => 'Usa HTTPS o una VPN para el acceso remoto. La verificación de certificados está activada; en el perfil se pueden configurar una CA personalizada y un certificado de cliente PEM.';

  @override
  String get message0090 => 'Completa este campo';

  @override
  String get message0091 => 'Confirmar';

  @override
  String get message0092 => 'Introduce un número entero igual o mayor que cero';

  @override
  String get message0093 => 'B';

  @override
  String get message0094 => 'KiB';

  @override
  String get message0095 => 'MiB';

  @override
  String get message0096 => 'GiB';

  @override
  String get message0097 => 'TiB';

  @override
  String get message0098 => 'Error en la operación RSS';

  @override
  String get message0099 => 'Actualizar';

  @override
  String get message0100 => 'Añadir';

  @override
  String get message0101 => 'Añadir canal RSS';

  @override
  String get message0102 => 'Crear carpeta';

  @override
  String get message0103 => 'Añadir regla';

  @override
  String get message0104 => 'Acciones de carpeta';

  @override
  String get message0105 => 'Artículos';

  @override
  String get message0106 => 'Canales';

  @override
  String get message0107 => 'Reglas';

  @override
  String get message0108 => 'Aún no hay artículos en los canales';

  @override
  String get message0109 => 'Sin título';

  @override
  String get message0110 => 'Torrent añadido';

  @override
  String get message0111 => 'Añadir torrent';

  @override
  String get message0112 => 'Marcar como leído';

  @override
  String get message0113 => 'Añade tu primer canal RSS con +';

  @override
  String get message0114 => 'Actualizar canal';

  @override
  String get message0115 => 'Marcar todo como leído';

  @override
  String get message0116 => 'Mover / renombrar';

  @override
  String get message0117 => 'Eliminar canal';

  @override
  String get message0118 => 'No hay reglas de descarga automática';

  @override
  String get message0119 => 'Editar';

  @override
  String get message0120 => 'Renombrar';

  @override
  String get message0121 => 'Artículos coincidentes';

  @override
  String get message0122 => 'Eliminar regla';

  @override
  String get message0123 => 'Carpeta RSS';

  @override
  String get message0124 => 'Ruta completa de la carpeta';

  @override
  String get message0125 => 'Acción de carpeta';

  @override
  String get message0126 => 'Eliminar carpeta';

  @override
  String get message0127 => 'Nuevo canal RSS';

  @override
  String get message0128 => 'Nueva carpeta RSS';

  @override
  String get message0129 => 'URL del canal';

  @override
  String get message0130 => 'Ruta y nombre del canal (opcional)';

  @override
  String get message0131 => 'Ruta de la nueva carpeta';

  @override
  String get message0132 => 'Nueva ruta RSS';

  @override
  String get message0133 => 'Ruta y nuevo nombre';

  @override
  String get message0134 => '¿Eliminar elemento RSS?';

  @override
  String message0135(String arg1) {
    return '“$arg1” y su contenido RSS se eliminarán. Los archivos torrent no se verán afectados.';
  }

  @override
  String get message0136 => '¿Eliminar regla?';

  @override
  String get message0137 => 'Nombre de la regla';

  @override
  String get message0138 => 'Nuevo nombre';

  @override
  String message0139(String arg1) {
    return 'Artículos coincidentes: $arg1';
  }

  @override
  String get message0140 => 'No hay artículos coincidentes';

  @override
  String get message0141 => 'Cerrar';

  @override
  String get message0142 => 'Nueva regla RSS';

  @override
  String get message0143 => 'Regla RSS';

  @override
  String get message0144 => 'Debe contener';

  @override
  String get message0145 => 'No debe contener';

  @override
  String get message0146 => 'Filtro de episodios';

  @override
  String get message0147 => 'URL de los canales, una por línea';

  @override
  String get message0148 => 'Categoría';

  @override
  String get message0149 => 'Ruta de guardado';

  @override
  String get message0150 => 'No volver a descargar durante, días';

  @override
  String get message0151 => 'Introduce un nombre para la regla';

  @override
  String get message0152 => 'Regla habilitada';

  @override
  String get message0153 => 'Expresiones regulares';

  @override
  String get message0154 => 'Filtro inteligente de episodios';

  @override
  String get message0155 => 'Añadir en pausa';

  @override
  String get message0156 => 'Complementos de búsqueda no disponibles';

  @override
  String get message0157 => 'Buscando en tu servidor…';

  @override
  String message0158(int arg1, String arg2) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 resultados',
      one: '$arg1 resultado',
    );
    return '$_temp0$arg2';
  }

  @override
  String get message0159 => ' · completada';

  @override
  String message0160(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 resultados',
      one: '$arg1 resultado',
    );
    return '$_temp0 · búsqueda detenida tras 2 minutos';
  }

  @override
  String get message0161 => 'La búsqueda falló';

  @override
  String get message0162 => 'No se pudo detener la búsqueda';

  @override
  String message0163(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 resultados',
      one: '$arg1 resultado',
    );
    return '$_temp0 · detenido';
  }

  @override
  String get message0164 => 'Búsqueda en el servidor';

  @override
  String get message0165 => 'Complementos de búsqueda';

  @override
  String get message0166 => 'Nombre del torrent';

  @override
  String get message0167 => 'Detener';

  @override
  String get message0168 => 'Buscar';

  @override
  String get message0169 => 'Complemento';

  @override
  String get message0170 => 'Todos los complementos';

  @override
  String get message0171 => 'Solo habilitados';

  @override
  String get message0172 => 'Todos';

  @override
  String get message0173 => 'Libros';

  @override
  String get message0174 => 'Juegos';

  @override
  String get message0175 => 'Películas';

  @override
  String get message0176 => 'Música';

  @override
  String get message0177 => 'Software';

  @override
  String get message0178 => 'Series de TV';

  @override
  String get message0179 => 'Introduce un término de búsqueda';

  @override
  String message0180(String arg1, String arg2, String arg3) {
    return '$arg1 · semillas $arg2\n$arg3';
  }

  @override
  String get message0181 => 'Añadir al servidor';

  @override
  String get message0182 => 'No se pudo añadir el torrent';

  @override
  String get message0183 => 'No se pudieron cambiar los complementos';

  @override
  String get message0184 => 'Instalar complemento de búsqueda';

  @override
  String get message0185 => 'URL del archivo del complemento';

  @override
  String get message0186 => 'El complemento se descargará e instalará en tu servidor de qBittorrent. Usa solo fuentes de confianza.';

  @override
  String get message0187 => 'Complementos de búsqueda';

  @override
  String get message0188 => 'Actualizar complementos';

  @override
  String get message0189 => 'Instalar complemento';

  @override
  String get message0190 => 'No hay complementos de búsqueda en el servidor';

  @override
  String message0191(String arg1) {
    return 'Versión $arg1';
  }

  @override
  String get message0192 => 'Eliminar complemento';

  @override
  String get message0193 => '¿Eliminar complemento?';

  @override
  String get message0194 => 'Nueva categoría';

  @override
  String get message0195 => 'Editar categoría';

  @override
  String get message0196 => 'Nombre';

  @override
  String get message0197 => 'Carpeta del servidor';

  @override
  String get message0198 => 'Categorías';

  @override
  String get message0199 => 'Eliminar categoría';

  @override
  String get message0200 => '¿Eliminar categoría?';

  @override
  String message0201(String arg1) {
    return '$arg1. Los torrents y los archivos se conservarán.';
  }

  @override
  String get message0202 => 'Etiquetas';

  @override
  String get message0203 => 'Crear etiquetas';

  @override
  String get message0204 => 'Nuevas etiquetas';

  @override
  String get message0205 => 'Nombres separados por comas';

  @override
  String get message0206 => 'Eliminar etiqueta';

  @override
  String get message0207 => '¿Eliminar etiqueta?';

  @override
  String message0208(String arg1) {
    return '$arg1. Los torrents y los archivos se conservarán.';
  }

  @override
  String get message0209 => 'Normal';

  @override
  String get message0210 => 'Información';

  @override
  String get message0211 => 'Advertencia';

  @override
  String get message0212 => 'Crítico';

  @override
  String get message0213 => 'Mensaje';

  @override
  String get message0214 => 'Registro de pares';

  @override
  String get message0215 => 'Nivel';

  @override
  String get message0216 => 'Todos los mensajes';

  @override
  String get message0217 => 'Advertencias';

  @override
  String get message0218 => 'Crítico';

  @override
  String get message0219 => 'Bloqueado';

  @override
  String get message0220 => 'Permitido';

  @override
  String get message0221 => 'Velocidad de descarga';

  @override
  String get message0222 => 'Velocidad de subida';

  @override
  String get message0223 => 'Descargado en esta sesión';

  @override
  String get message0224 => 'Subido en esta sesión';

  @override
  String get message0225 => 'Límite de descarga';

  @override
  String get message0226 => 'Límite de subida';

  @override
  String get message0227 => 'Nodos DHT';

  @override
  String get message0228 => 'Conexión';

  @override
  String message0229(String arg1) {
    return '$arg1/s';
  }

  @override
  String get message0230 => 'Conectado';

  @override
  String get message0231 => 'Detrás de NAT / cortafuegos';

  @override
  String get message0232 => 'No conectado';

  @override
  String get message0233 => 'Categorías y etiquetas';

  @override
  String get message0234 => 'Estado del servidor';

  @override
  String get message0235 => 'No se pudo cargar la configuración';

  @override
  String get message0236 => '¿Cambiar WebUI?';

  @override
  String get message0237 => 'Cambiar la dirección, el puerto o la autenticación puede desconectarte.';

  @override
  String get message0238 => 'Configuración guardada. Si cambiaron la dirección, el puerto o la contraseña de la WebUI, actualiza tu perfil de conexión.';

  @override
  String get message0239 => 'Configuración guardada';

  @override
  String get message0240 => 'No se pudo guardar la configuración';

  @override
  String get message0241 => 'Introduzca un número entero';

  @override
  String get message0242 => 'El puerto debe estar entre 1–65535';

  @override
  String get message0243 => 'La hora debe estar entre 0–23';

  @override
  String get message0244 => 'Los minutos deben estar entre 0–59';

  @override
  String get message0245 => 'Mínimo −1 (si el servidor lo admite)';

  @override
  String get message0246 => 'Ajustes JSON avanzados';

  @override
  String get message0247 => 'Todos los ajustes del servidor actual. Solo se guardan las claves modificadas.';

  @override
  String get message0248 => 'Ajustes JSON no válidos';

  @override
  String get message0249 => 'Descargas';

  @override
  String get message0250 => 'Carpeta de guardado';

  @override
  String get message0251 => 'Carpeta temporal';

  @override
  String get message0252 => 'Usar carpeta temporal';

  @override
  String get message0253 => 'Añadir en pausa';

  @override
  String get message0254 => 'Gestión automática de torrents';

  @override
  String get message0255 => 'Preasignar espacio en disco';

  @override
  String get message0256 => 'Extensión para archivos incompletos';

  @override
  String get message0257 => 'Carpeta de exportación de .torrent';

  @override
  String get message0258 => 'Exportar archivos .torrent terminados';

  @override
  String get message0259 => 'Puerto de entrada';

  @override
  String get message0260 => 'Puerto aleatorio al iniciar';

  @override
  String get message0261 => 'Conexiones máximas (-1 = sin límite)';

  @override
  String get message0262 => 'Conexiones por torrent';

  @override
  String get message0263 => 'Ranuras de subida';

  @override
  String get message0264 => 'Dirección del proxy';

  @override
  String get message0265 => 'Puerto del proxy';

  @override
  String get message0266 => 'Nombre de usuario del proxy';

  @override
  String get message0267 => 'Contraseña del proxy';

  @override
  String get message0268 => 'Velocidad';

  @override
  String get message0269 => 'Descarga, bytes/s (0 = sin límite)';

  @override
  String get message0270 => 'Subida, bytes/s (0 = sin límite)';

  @override
  String get message0271 => 'Descarga alternativa, bytes/s';

  @override
  String get message0272 => 'Subida alternativa, bytes/s';

  @override
  String get message0273 => 'Programación de límites alternativos';

  @override
  String get message0274 => 'Inicio: hora';

  @override
  String get message0275 => 'Inicio: minuto';

  @override
  String get message0276 => 'Fin: hora';

  @override
  String get message0277 => 'Fin: minuto';

  @override
  String get message0278 => 'Incluir la sobrecarga del protocolo en los límites';

  @override
  String get message0279 => 'Limitar pares locales';

  @override
  String get message0280 => 'Intercambio de pares (PeX)';

  @override
  String get message0281 => 'Descubrimiento de pares locales';

  @override
  String get message0282 => 'Modo anónimo';

  @override
  String get message0283 => 'Cola de torrents';

  @override
  String get message0284 => 'Descargas activas';

  @override
  String get message0285 => 'Subidas activas';

  @override
  String get message0286 => 'Torrents activos';

  @override
  String get message0287 => 'No contar torrents lentos';

  @override
  String get message0288 => 'Añadir trackers automáticamente';

  @override
  String get message0289 => 'Trackers adicionales';

  @override
  String get message0290 => 'Dirección de escucha';

  @override
  String get message0291 => 'Puerto de WebUI';

  @override
  String get message0292 => 'Nombre de usuario';

  @override
  String get message0293 => 'Nueva contraseña';

  @override
  String get message0294 => 'Autenticación de localhost';

  @override
  String get message0295 => 'Protección CSRF';

  @override
  String get message0296 => 'Protección contra clickjacking';

  @override
  String get message0297 => 'Tiempo de espera de sesión, segundos';

  @override
  String get message0298 => 'Activar fuentes RSS';

  @override
  String get message0299 => 'Descarga automática por reglas';

  @override
  String get message0300 => 'Intervalo de actualización, minutos';

  @override
  String get message0301 => 'Artículos por fuente';

  @override
  String get message0302 => 'Filtros de episodios';

  @override
  String get message0303 => 'Todos los ajustes (JSON)';

  @override
  String get message0304 => 'Ajustes y opciones avanzadas para la versión del servidor';

  @override
  String get message0305 => 'No se pudo completar la acción';

  @override
  String get message0306 => 'Cambios aplicados';

  @override
  String get message0307 => 'Gestionar torrent';

  @override
  String get message0308 => 'Organizar';

  @override
  String get message0309 => 'Nombre del torrent';

  @override
  String get message0310 => 'Renombrar torrent';

  @override
  String get message0311 => 'Mover archivos';

  @override
  String get message0312 => 'Nueva ruta en el servidor';

  @override
  String get message0313 => 'Ruta completa';

  @override
  String get message0314 => 'qBittorrent mueve los archivos en el servidor';

  @override
  String get message0315 => 'Añadir etiquetas';

  @override
  String get message0316 => 'Etiquetas, separadas por comas';

  @override
  String get message0317 => 'Quitar etiquetas';

  @override
  String get message0318 => 'Velocidad y siembra';

  @override
  String get message0319 => 'Límites de velocidad';

  @override
  String get message0320 => 'Límites de siembra';

  @override
  String get message0321 => 'Forzar inicio';

  @override
  String get message0322 => 'Supersiembra';

  @override
  String get message0323 => 'Alternar descarga secuencial';

  @override
  String get message0324 => 'Alternar prioridad de primera/última pieza';

  @override
  String get message0325 => 'Forzar nueva comprobación';

  @override
  String get message0326 => '¿Volver a comprobar los archivos?';

  @override
  String get message0327 => 'La nueva comprobación puede tardar un poco y pausar temporalmente las transferencias.';

  @override
  String get message0328 => 'Volver a anunciar a los trackers';

  @override
  String get message0329 => 'Cola';

  @override
  String get message0330 => 'Mover al principio';

  @override
  String get message0331 => 'Subir';

  @override
  String get message0332 => 'Bajar';

  @override
  String get message0333 => 'Mover al final';

  @override
  String get message0334 => 'Contenido y conexiones';

  @override
  String get message0335 => 'Exportar .torrent';

  @override
  String get message0336 => 'Archivos y prioridades';

  @override
  String get message0337 => 'Renombrar carpeta';

  @override
  String get message0338 => 'Ruta actual dentro del torrent';

  @override
  String get message0339 => 'Nueva ruta dentro del torrent';

  @override
  String get message0340 => 'Trackers';

  @override
  String get message0341 => 'Pares';

  @override
  String get message0342 => 'Fuentes HTTP';

  @override
  String get message0343 => 'Estados de las piezas';

  @override
  String get message0344 => 'Sin categoría';

  @override
  String get message0345 => 'Descarga, KiB/s';

  @override
  String get message0346 => 'Subida, KiB/s';

  @override
  String get message0347 => '0 = sin límite. 1 KiB/s = 1024 bytes/s.';

  @override
  String get message0348 => 'Ratio';

  @override
  String get message0349 => 'Introduce un número';

  @override
  String get message0350 => 'Tiempo de siembra, minutos';

  @override
  String get message0351 => 'Introduce un número entero';

  @override
  String get message0352 => 'Tiempo de siembra inactiva, minutos';

  @override
  String get message0353 => '-2 = usar la configuración del servidor, -1 = sin límite.';

  @override
  String get message0354 => 'Activar';

  @override
  String get message0355 => 'Desactivar';

  @override
  String get message0356 => 'Archivos';

  @override
  String message0357(String arg1, String arg2) {
    return '$arg1 · prioridad $arg2';
  }

  @override
  String get message0358 => 'Renombrar archivo';

  @override
  String get message0359 => 'Cambios aplicados. Vuelve a abrir la lista para actualizarla.';

  @override
  String get message0360 => 'La acción falló';

  @override
  String get message0361 => 'No descargar';

  @override
  String get message0362 => 'Prioridad normal';

  @override
  String get message0363 => 'Prioridad alta';

  @override
  String get message0364 => 'Prioridad máxima';

  @override
  String get message0365 => 'Editar tracker';

  @override
  String get message0366 => 'Nueva URL';

  @override
  String get message0367 => '¿Quitar tracker?';

  @override
  String get message0368 => 'No se pudo editar el tracker';

  @override
  String get message0369 => 'Quitar';

  @override
  String get message0370 => 'Añadir trackers';

  @override
  String get message0371 => 'URL, una por línea';

  @override
  String get message0372 => 'No se pudieron añadir los trackers';

  @override
  String get message0373 => 'No hay pares conectados';

  @override
  String message0374(String arg1, String arg2) {
    return '$arg1 · ↓ $arg2/s';
  }

  @override
  String get message0375 => 'Añadir pares';

  @override
  String get message0376 => 'IP:puerto, separados por |';

  @override
  String get message0377 => 'No se pudieron añadir los pares';

  @override
  String message0378(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 piezas',
      one: '$arg1 pieza',
    );
    return '$_temp0';
  }

  @override
  String get message0379 => 'Gris: faltante, azul: descargando, verde: completada. Mostrando las primeras 4096 piezas.';

  @override
  String message0380(String arg1) {
    return 'Pieza $arg1';
  }

  @override
  String get message0381 => 'Exportación completada';

  @override
  String get message0382 => 'Exportación cancelada';

  @override
  String get message0383 => 'Introduce una URL';

  @override
  String get message0384 => 'La URL no debe contener espacios, caracteres de control ni \"|\"';

  @override
  String get message0385 => 'Introduce una dirección http:// o https:// con un nombre de host';

  @override
  String get message0386 => 'Introduce al menos una URL';

  @override
  String get message0387 => 'El servidor no admite cambiar las fuentes HTTP. ';

  @override
  String get message0388 => 'Requiere qBittorrent 5.2 o posterior; solo de lectura.';

  @override
  String get message0389 => 'No se pudieron cargar las fuentes HTTP';

  @override
  String get message0390 => 'Añadir fuentes HTTP';

  @override
  String get message0391 => 'Las direcciones se envían al servidor de qBittorrent; la aplicación no se conecta directamente a ellas.';

  @override
  String get message0392 => 'No se pudieron añadir las fuentes HTTP';

  @override
  String get message0393 => 'Editar fuente HTTP';

  @override
  String get message0394 => 'Dirección sin cambios';

  @override
  String get message0395 => 'No se pudo editar la fuente HTTP';

  @override
  String get message0396 => '¿Quitar fuente HTTP?';

  @override
  String get message0397 => 'No se pudo quitar la fuente HTTP';

  @override
  String get message0398 => 'Añadir fuentes';

  @override
  String get message0399 => 'Editar fuentes HTTP requiere qBittorrent 5.2 o posterior. ';

  @override
  String get message0400 => 'Un servidor más antiguo podría rechazar los cambios.';

  @override
  String get message0401 => 'Reintentar';

  @override
  String get message0402 => 'No hay fuentes HTTP';

  @override
  String get message0403 => 'No se pudo inicializar el almacenamiento seguro.';

  @override
  String get message0404 => '¿Añadir torrent entrante?';

  @override
  String message0405(String arg1) {
    return 'Servidor: $arg1';
  }

  @override
  String get message0406 => 'Un archivo .torrent';

  @override
  String get message0407 => 'Un enlace';

  @override
  String get message0408 => 'Archivo .torrent';

  @override
  String get message0409 => 'No se pudieron eliminar los datos locales.';

  @override
  String get message0410 => 'Home qB bloqueado';

  @override
  String get message0411 => 'Abrir';

  @override
  String get message0412 => 'Restablecer datos locales';

  @override
  String get message0413 => 'Los perfiles, las contraseñas y los certificados se eliminarán de este dispositivo. Los torrents del servidor se conservarán.';

  @override
  String get message0414 => 'Eliminar datos locales';

  @override
  String get message0415 => 'No se pudo leer la configuración del dispositivo desde el almacenamiento seguro.';

  @override
  String get message0416 => 'No se pudo programar la consulta en segundo plano en este dispositivo.';

  @override
  String get message0417 => 'La consulta en segundo plano está disponible en Android e iOS. Las notificaciones de escritorio requieren que la aplicación permanezca abierta.';

  @override
  String get message0418 => 'Las notificaciones no están configuradas en esta plataforma.';

  @override
  String get message0419 => 'Las notificaciones del sistema no están disponibles.';

  @override
  String get message0420 => 'No se pudieron inicializar las notificaciones del sistema.';

  @override
  String get message0421 => 'Android puede retrasar la consulta debido a restricciones de batería, red o segundo plano.';

  @override
  String get message0422 => 'Elija un intervalo de consulta entre 15 y 1440 minutos.';

  @override
  String get message0423 => 'Se guardó el nuevo intervalo, pero no se pudo actualizar la programación en segundo plano.';

  @override
  String get message0424 => 'Las notificaciones no están disponibles.';

  @override
  String get message0425 => 'No se concedió el permiso de notificaciones.';

  @override
  String get message0426 => 'No se pudo actualizar la programación en segundo plano. Las comprobaciones de notificaciones en primer plano siguen funcionando.';

  @override
  String get message0427 => 'Desbloquear Home qB Remote';

  @override
  String get message0428 => 'No se completó la autenticación del dispositivo.';

  @override
  String get message0429 => 'No se pudo activar la protección de capturas de pantalla.';

  @override
  String get message0430 => 'No se pudieron eliminar las notificaciones del sistema.';

  @override
  String get message0431 => 'No se pudo cancelar la comprobación en segundo plano.';

  @override
  String get message0432 => 'Descarga completada';

  @override
  String get message0433 => 'Descarga completada. Abra la aplicación para verla.';

  @override
  String get message0434 => 'Descargas completadas';

  @override
  String get message0435 => 'Descargas completadas en sus servidores qBittorrent';

  @override
  String get message0436 => 'Se agotó el presupuesto de análisis en segundo plano.';

  @override
  String get message0437 => 'Solo se puede importar un documento .torrent local.';

  @override
  String get message0438 => 'La importación de documentos no es compatible con esta plataforma.';

  @override
  String get message0439 => 'La importación de documentos no está disponible en esta versión de la aplicación.';

  @override
  String get message0440 => 'El sistema rechazó el documento.';

  @override
  String get message0441 => 'No se pudo leer el documento torrent.';

  @override
  String get message0442 => 'El documento torrent está vacío.';

  @override
  String get message0443 => 'El documento torrent supera los 16 MiB y no se puede importar.';

  @override
  String get message0444 => 'El documento no es un archivo .torrent válido.';

  @override
  String get message0445 => 'Ruso';

  @override
  String get message0446 => 'Ucraniano';

  @override
  String get message0447 => 'Idioma no compatible';

  @override
  String get message0448 => 'Otra exportación sigue en curso.';

  @override
  String get message0449 => 'La exportación no es compatible con esta plataforma.';

  @override
  String get message0450 => 'No hay datos de torrent para exportar.';

  @override
  String get message0451 => 'El archivo torrent supera los 16 MiB y no se puede exportar.';

  @override
  String get message0452 => 'Los datos del torrent no son una secuencia de bytes válida.';

  @override
  String get message0453 => 'La exportación no está disponible en esta versión de la aplicación.';

  @override
  String get message0454 => 'El sistema rechazó los datos del torrent.';

  @override
  String get message0455 => 'No se pudo guardar el archivo torrent.';

  @override
  String get message0456 => 'No se pudo abrir el diálogo de guardado.';

  @override
  String get message0457 => 'No se pudo escribir el archivo torrent en la ubicación elegida.';

  @override
  String get message0458 => 'Introduzca un número entero desde 0';

  @override
  String get message0459 => 'Nueva descarga';

  @override
  String get message0460 => 'Enlaces magnet o URL';

  @override
  String get message0461 => 'Un enlace por línea';

  @override
  String get message0462 => 'Elegir archivo .torrent';

  @override
  String get message0463 => 'Opciones de descarga';

  @override
  String get message0464 => 'Etiquetas, separadas por comas';

  @override
  String get message0465 => 'Nuevo nombre (opcional)';

  @override
  String get message0466 => 'Límite de descarga, KiB/s';

  @override
  String get message0467 => '0 — sin límite; vacío — configuración del servidor';

  @override
  String get message0468 => 'Límite de subida, KiB/s';

  @override
  String get message0469 => 'Estructura de archivos';

  @override
  String get message0470 => 'Como en el torrent';

  @override
  String get message0471 => 'Crear subcarpeta';

  @override
  String get message0472 => 'Sin subcarpeta';

  @override
  String get message0473 => 'Añadir en pausa';

  @override
  String get message0474 => 'Descarga secuencial';

  @override
  String get message0475 => 'Primeras y últimas piezas primero';

  @override
  String get message0476 => 'Contraseña PKCS#12';

  @override
  String get message0477 => 'Contraseña del contenedor';

  @override
  String get message0478 => 'Importar';

  @override
  String get message0479 => 'Home qB';

  @override
  String get message0480 => 'Administrar servidores';

  @override
  String get message0481 => 'Ajustes de la app';

  @override
  String get message0482 => 'TU CONEXIÓN';

  @override
  String get message0483 => 'No hay ningún servidor seleccionado';

  @override
  String get message0484 => 'Servidores';

  @override
  String get message0485 => 'RSS, búsqueda, ajustes';

  @override
  String get message0486 => 'Descargando';

  @override
  String get message0487 => 'Distribuyendo';

  @override
  String get message0488 => 'Pausados';

  @override
  String get message0489 => 'Errores';

  @override
  String get message0490 => 'Todos los torrents';

  @override
  String get message0491 => 'Solo tus servidores.\nSin anuncios ni telemetría.';

  @override
  String get message0492 => 'Tus descargas, al alcance de la mano';

  @override
  String get message0493 => 'Conecta tu qBittorrent de casa mediante la Web UI.\nLa dirección del servidor y los ajustes se guardan en este dispositivo.';

  @override
  String get message0494 => 'Conectar servidor';

  @override
  String get message0495 => 'Explorar descargas';

  @override
  String get message0496 => 'Servidor actual';

  @override
  String message0497(String arg1) {
    return '$arg1/s';
  }

  @override
  String message0498(String arg1) {
    return '$arg1/s';
  }

  @override
  String get message0499 => 'Torrents';

  @override
  String get message0500 => 'Buscar torrent por nombre';

  @override
  String message0501(String arg1) {
    return 'Seleccionado: $arg1';
  }

  @override
  String get message0502 => 'Reanudar seleccionados';

  @override
  String get message0503 => 'Pausar seleccionados';

  @override
  String get message0504 => 'Eliminar seleccionados';

  @override
  String get message0505 => 'Borrar selección';

  @override
  String get message0506 => 'No se encontró nada';

  @override
  String get message0507 => 'Aún no hay torrents';

  @override
  String get message0508 => 'Añade un enlace magnet, una URL o un archivo .torrent.';

  @override
  String get message0509 => 'Reanudar';

  @override
  String get message0510 => 'Pausar';

  @override
  String get message0511 => 'Acciones';

  @override
  String get message0512 => 'Detalles';

  @override
  String get message0513 => 'Eliminar…';

  @override
  String message0514(String arg1) {
    return '↓ $arg1/s';
  }

  @override
  String message0515(String arg1) {
    return '↑ $arg1/s';
  }

  @override
  String get message0516 => 'No se pudo completar la acción. Comprueba la conexión con el servidor.';

  @override
  String get message0517 => 'Mis servidores';

  @override
  String get message0518 => 'Ajustes del servidor';

  @override
  String get message0519 => 'Editar';

  @override
  String get message0520 => 'Eliminar perfil';

  @override
  String get message0521 => 'Añadir servidor';

  @override
  String get message0522 => '¿Eliminar perfil?';

  @override
  String message0523(String arg1) {
    return 'El perfil “$arg1” se eliminará de este dispositivo. Los torrents del servidor se conservarán.';
  }

  @override
  String get message0524 => '¿Usar HTTP local?';

  @override
  String get message0525 => 'El SSID no verifica la identidad de la red. En otra red con el mismo nombre, tu contraseña podría llegar a un servidor no autorizado. Para protegerte, usa HTTPS con verificación de certificado o una VPN.';

  @override
  String get message0526 => 'Elige un archivo .torrent de hasta 16 MB.';

  @override
  String get message0527 => 'No se pudo abrir el archivo seleccionado.';

  @override
  String get message0528 => '¿Eliminar torrent?';

  @override
  String message0529(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '¿Eliminar $arg1 torrents?',
      one: '¿Eliminar $arg1 torrent?',
    );
    return '$_temp0';
  }

  @override
  String get message0530 => 'De forma predeterminada, los archivos descargados se mantendrán en el servidor.';

  @override
  String get message0531 => 'Eliminar también los archivos del servidor';

  @override
  String get message0532 => 'Esta acción no se puede deshacer';

  @override
  String get message0533 => 'Servidor de casa';

  @override
  String get message0534 => 'No se pudo importar PKCS#12. Comprueba la contraseña y el archivo (hasta 4 MB).';

  @override
  String get message0535 => 'Introduce un nombre';

  @override
  String get message0536 => 'Dirección de la Web UI';

  @override
  String get message0537 => 'HTTP o HTTPS, incluido el puerto y la ruta';

  @override
  String get message0538 => 'Introduce la dirección completa del servidor HTTP(S)';

  @override
  String get message0539 => 'Quita la contraseña, los parámetros y # de la dirección';

  @override
  String get message0540 => 'Contraseña';

  @override
  String get message0541 => 'Ocultar contraseña';

  @override
  String get message0542 => 'Mostrar contraseña';

  @override
  String get message0543 => 'Clave API (opcional)';

  @override
  String get message0544 => 'qBittorrent 5.2+. Si se rellena, se usa en lugar del usuario y la contraseña.';

  @override
  String get message0545 => 'La clave API no se puede combinar con un proxy de autenticación Basic';

  @override
  String get message0546 => 'Dirección Wi-Fi local';

  @override
  String get message0547 => 'Opcional. El SSID se usa solo en el dispositivo para elegir una dirección. El sistema puede pedir permiso de ubicación para leer el nombre de la Wi-Fi; no se leen las coordenadas.';

  @override
  String get message0548 => 'URL local';

  @override
  String get message0549 => 'Introduce una dirección HTTP(S) sin contraseña ni parámetros';

  @override
  String get message0550 => 'Red Wi-Fi de casa (SSID)';

  @override
  String get message0551 => 'SSID no disponible. Puedes introducir el nombre de la red manualmente.';

  @override
  String get message0552 => 'Leer red actual';

  @override
  String get message0553 => 'Proxy y certificados';

  @override
  String get message0554 => 'Autenticación Basic para proxy inverso; PEM para HTTPS y certificado de cliente.';

  @override
  String get message0555 => 'Basic auth: usuario';

  @override
  String get message0556 => 'Basic auth: contraseña';

  @override
  String get message0557 => 'CA personalizada (PEM)';

  @override
  String get message0558 => 'Certificado de cliente (PEM)';

  @override
  String get message0559 => 'Clave privada (PEM)';

  @override
  String get message0560 => 'Importar PKCS#12 (.p12/.pfx)';

  @override
  String get message0561 => 'Contraseña de la clave privada';

  @override
  String get message0562 => 'El archivo PEM debe ser menor de 1 MB.';

  @override
  String get message0563 => 'No se pudo leer el archivo PEM.';

  @override
  String get message0564 => 'Importar archivo';

  @override
  String get message0565 => 'Acciones del torrent';

  @override
  String get message0566 => 'Volver a comprobar';

  @override
  String get message0567 => 'Actualizar rastreadores';

  @override
  String get message0568 => 'Forzar inicio';

  @override
  String get message0569 => 'Primera y última piezas';

  @override
  String get message0570 => 'No se pudieron cargar los detalles del torrent.';

  @override
  String get message0571 => 'Examinar';

  @override
  String get message0572 => 'La lista de archivos está vacía';

  @override
  String get message0573 => 'Archivo';

  @override
  String get message0574 => 'Prioridad del archivo';

  @override
  String get message0575 => 'Alta';

  @override
  String get message0576 => 'Máxima';

  @override
  String get message0577 => 'Sin rastreadores';

  @override
  String get message0578 => 'Rastreador';

  @override
  String get message0579 => 'No se pudo cambiar el torrent.';

  @override
  String get message0580 => 'Estado';

  @override
  String get message0581 => 'Tamaño';

  @override
  String get message0582 => 'Completado';

  @override
  String get message0583 => 'Descargado';

  @override
  String get message0584 => 'Subido';

  @override
  String get message0585 => 'Comentario';

  @override
  String get message0586 => 'Hash';

  @override
  String get message0587 => 'KB';

  @override
  String get message0588 => 'MB';

  @override
  String get message0589 => 'GB';

  @override
  String get message0590 => 'TB';

  @override
  String get message0591 => 'Error';

  @override
  String get message0592 => 'Comprobando';

  @override
  String get message0593 => 'Moviendo';

  @override
  String get message0594 => 'En cola';

  @override
  String get message0595 => 'Metadatos';

  @override
  String get message0596 => 'Servidor';

  @override
  String get message0597 => 'No consultado';

  @override
  String get message0598 => 'Caído';

  @override
  String get message0599 => 'Funcionando';

  @override
  String get message0600 => 'Actualizando';

  @override
  String get message0601 => 'Estado desconocido';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get systemLanguage => 'Predeterminado del sistema';

  @override
  String get languageFollowSystemDescription => 'Usar el idioma del dispositivo';

  @override
  String get languageChangeFailed => 'No se pudo cambiar el idioma. Inténtalo de nuevo.';

  @override
  String get startupStorageFailed => 'No se pudo leer el almacenamiento protegido. Inténtalo de nuevo.';

  @override
  String get localDataResetFailed => 'No se pudieron eliminar los datos locales. Inténtalo de nuevo.';

  @override
  String get appLocked => 'Aplicación bloqueada';

  @override
  String get open => 'Abrir';

  @override
  String get resetLocalData => 'Restablecer datos locales';

  @override
  String get resetLocalDataWarning => 'Se eliminarán los perfiles guardados, las credenciales y la configuración del dispositivo. Esta acción no se puede deshacer.';

  @override
  String get deleteLocalData => 'Eliminar datos locales';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Añadir';

  @override
  String get incomingTorrentTitle => '¿Añadir torrent entrante?';

  @override
  String serverName(String name) {
    return 'Servidor: $name';
  }

  @override
  String get incomingTorrentFile => 'Un archivo .torrent';

  @override
  String get incomingTorrentLink => 'Un enlace';

  @override
  String get torrentFile => 'Archivo torrent';

  @override
  String get unlockReason => 'Desbloquear Home qB Remote';

  @override
  String get downloadComplete => 'Descarga completada';

  @override
  String get downloadCompletePrivate => 'Descarga completada. Abre la aplicación para verla.';

  @override
  String get completionChannelName => 'Descargas completadas';

  @override
  String get completionChannelDescription => 'Descargas completadas en tus servidores de qBittorrent';
}
