# Dockerfile de Angular
FROM node:16.17.1alpine as build-stage

WORKDIR /app

# Copiar el archivo package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Instalar Angular CLI
RUN npm install -g @angular/cli

# Copiar el resto de los archivos de la aplicación
COPY . .

# Construir la aplicación Angular
RUN ng build

# Configurar Nginx para servir la aplicación construida
FROM nginx:1.21.1-alpine

# Copiar el archivo de configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos generados de la aplicación
COPY --from=build-stage /app/dist/PDMA_PlayFutDay /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]