-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-06-2025 a las 17:09:54
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `geoplanner_social`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `amistades`
--

CREATE TABLE `amistades` (
  `id_usuario_solicitante` int(11) NOT NULL,
  `id_usuario_receptor` int(11) NOT NULL,
  `estado` enum('pendiente','aceptada','bloqueada') NOT NULL,
  `fecha_solicitud` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `id_comentario` int(11) NOT NULL,
  `id_publicacion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `contenido` text NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participantes`
--

CREATE TABLE `participantes` (
  `id_publicacion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `rol` enum('organizador','asistente') NOT NULL DEFAULT 'asistente',
  `fecha_confirmacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publicaciones`
--

CREATE TABLE `publicaciones` (
  `id_publicacion` int(11) NOT NULL COMMENT 'La llave primaria.',
  `id_creador` int(11) NOT NULL COMMENT 'Llave foranea',
  `titulo` varchar(100) NOT NULL,
  `descripcion` text NOT NULL COMMENT 'Para textos largos.',
  `tipo` enum('tarea','evento','recordatorio') NOT NULL COMMENT 'Tipo de publicación.',
  `fecha_evento` datetime NOT NULL COMMENT 'Fecha y hora del evento.',
  `latitud` decimal(10,7) NOT NULL,
  `longitud` decimal(10,7) NOT NULL,
  `nombre_ubicacion` varchar(150) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL COMMENT 'La llave primaria unica',
  `nombre_usuario` varchar(30) NOT NULL COMMENT 'El @usuario para iniciar sesión.',
  `email` varchar(100) NOT NULL COMMENT 'El correo para registro.',
  `password_hash` varchar(255) NOT NULL COMMENT 'Aqui ira la contraseña encriptada',
  `nombre_completo` varchar(100) DEFAULT NULL,
  `foto_perfil_url` varchar(255) DEFAULT NULL COMMENT 'la URL de la imagen de perfil.',
  `biografia` varchar(160) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `amistades`
--
ALTER TABLE `amistades`
  ADD PRIMARY KEY (`id_usuario_solicitante`,`id_usuario_receptor`),
  ADD KEY `fk_amistad_receptor` (`id_usuario_receptor`);

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id_comentario`),
  ADD KEY `publicacion_comentario` (`id_publicacion`),
  ADD KEY `usuario_comentario` (`id_usuario`);

--
-- Indices de la tabla `participantes`
--
ALTER TABLE `participantes`
  ADD PRIMARY KEY (`id_publicacion`,`id_usuario`),
  ADD KEY `fk_participante_usuario` (`id_usuario`);

--
-- Indices de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD PRIMARY KEY (`id_publicacion`),
  ADD KEY `publicaciones_ibfk_1` (`id_creador`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `Nombre_usuario` (`nombre_usuario`),
  ADD UNIQUE KEY `Email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id_comentario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id_publicacion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'La llave primaria.';

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'La llave primaria unica';

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `amistades`
--
ALTER TABLE `amistades`
  ADD CONSTRAINT `fk_amistad_receptor` FOREIGN KEY (`id_usuario_receptor`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_amistad_solicitante` FOREIGN KEY (`id_usuario_solicitante`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `publicacion_comentario` FOREIGN KEY (`id_publicacion`) REFERENCES `publicaciones` (`id_publicacion`) ON DELETE CASCADE,
  ADD CONSTRAINT `usuario_comentario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `participantes`
--
ALTER TABLE `participantes`
  ADD CONSTRAINT `fk_participante_publicacion` FOREIGN KEY (`id_publicacion`) REFERENCES `publicaciones` (`id_publicacion`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_participante_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD CONSTRAINT `publicaciones_ibfk_1` FOREIGN KEY (`id_creador`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
