# test-spring-boot-api

Demo de una aplicación Spring Boot con una API REST para gestionar usuarios.

## Imagen Docker

Disponible en Docker Hub:  
 [celis227/spring-boot-app](https://hub.docker.com/r/celis227/spring-boot-app)

## Requisitos Previos

Asegúrate de tener instalados los siguientes programas:

- Docker: https://www.docker.com/
- Docker Compose: https://docs.docker.com/compose/

---

## Estructura del Proyecto

El archivo `docker-compose.yml` define los siguientes servicios:

1. **Aplicación Spring Boot (`spring-boot-app`)**:
   - Imagen: `celis227/spring-boot-app:1.0`
   - Puerto expuesto: `8080` en la máquina host.

2. **Base de Datos MySQL (`database`)**:
   - Imagen: `mysql:8.0`
   - Puerto expuesto: `3307` en la máquina host.
   - Base de datos preconfigurada: `user_management`.

3. **Red (`spring-network`)**:
   - Red tipo `bridge` para permitir la comunicación entre los servicios.

4. **Volumen (`db_data`)**:
   - Volumen de Docker para persistir los datos de la base de datos.

---

## Pasos para Ejecutar

### 1. Clonar el Repositorio y cambiarse a la ruta del repositorio

git clone 

### 2. Ejecutar Docker Compose
Ejecuta el siguiente comando para iniciar los servicios:

docker-compose up -d

### 3. Verificar el funcionamiento de la REST API

### Crear un usuario

```bash
curl --location 'http://localhost:8080/api/users' \
--header 'Content-Type: application/json' \
--data-raw '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "johndoe@gmail.com"
}'

```

### Obtener usuarios

```bash
curl --location 'localhost:8080/api/users'

```

### Obtener usuario
```bash
curl --location 'localhost:8080/api/users/1'

```

### Modificar usuario
```bash
curl --location --request PUT 'localhost:8080/api/users/1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "firstName": "John",
    "lastName":"Doe",
    "email": "johndoe@gmail.com"
}'

```

### Eliminar usuario
```bash
curl --location --request DELETE 'localhost:8080/api/users/1'

```

### 4. Detener los Servicios
Para detener los servicios, ejecuta:

docker-compose down

---

## Variables de Entorno

Las siguientes variables de entorno están configuradas en el archivo `docker-compose.yml`:

### Aplicación Spring Boot (`spring-boot-app`)
- `SPRING_DATASOURCE_URL`: URL JDBC para la base de datos MySQL.
- `SPRING_DATASOURCE_USERNAME`: Usuario de la base de datos.
- `SPRING_DATASOURCE_PASSWORD`: Contraseña de la base de datos.
- `SPRING_JPA_HIBERNATE_DDL_AUTO`: Propiedad de Hibernate que define cómo operar el esquema de la base de datos en el arranque.

### Base de Datos MySQL (`database`)
- `MYSQL_ROOT_PASSWORD`: Contraseña del usuario root de MySQL.
- `MYSQL_DATABASE`: Nombre de la base de datos a crear.

