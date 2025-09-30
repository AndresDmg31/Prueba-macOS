# Prueba-macOS

Prueba técnica que simula una extensión de proveedor de archivos en macOS usando NSFileProvider.  
El proyecto incluye un menú en la barra de estado para conectar, desconectar y refrescar el dominio llamado "Pokémon Drive".

## Características

- Extensión de File Provider integrada en macOS.
- Enumeración básica de archivos.
- Acceso a un archivo de ejemplo incluido en el bundle.
- API lista para integración si se desea extender la funcionalidad.

## Instrucciones

1. Ejecutar la app principal (PokemonDrive) desde Xcode.
2. En la barra superior, hacer clic en el ícono del rayo ⚡️.
3. Usar las opciones:
   - **Conectar**: Registra el dominio del File Provider.
   - **Refrescar lista**: Simula la actualización del contenido.
   - **Desconectar**: Elimina el dominio.

   > Para ver los archivos montados, activa la extensión en Preferencias del Sistema > Extensiones > File Provider. 

# Autor

Andrés Martínez — iOS/Flutter Developer

