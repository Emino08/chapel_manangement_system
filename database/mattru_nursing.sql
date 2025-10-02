/*
 Navicat Premium Dump SQL

 Source Server         : Mattru Nursing
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:4306
 Source Schema         : mattru_nursing

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 02/10/2025 18:56:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for application_progress
-- ----------------------------
DROP TABLE IF EXISTS `application_progress`;
CREATE TABLE `application_progress`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `form_data` json NOT NULL,
  `files_metadata` json NULL,
  `current_step` int NULL DEFAULT 0,
  `completed_steps` json NULL,
  `last_saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_user_progress`(`user_id` ASC) USING BTREE,
  CONSTRAINT `application_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1020 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of application_progress
-- ----------------------------
INSERT INTO `application_progress` VALUES (535, 8, '[]', '[]', 0, '\"[]\"', '2025-08-14 01:33:57', '2025-08-13 13:49:31');

-- ----------------------------
-- Table structure for application_responses
-- ----------------------------
DROP TABLE IF EXISTS `application_responses`;
CREATE TABLE `application_responses`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `question_id` int NOT NULL,
  `response_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `application_id`(`application_id` ASC) USING BTREE,
  INDEX `question_id`(`question_id` ASC) USING BTREE,
  CONSTRAINT `application_responses_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `application_responses_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 301 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of application_responses
-- ----------------------------
INSERT INTO `application_responses` VALUES (1, 8, 1, NULL, NULL, '2025-07-19 22:23:36', 'Bank Transfer');
INSERT INTO `application_responses` VALUES (2, 8, 2, NULL, NULL, '2025-07-19 22:23:36', '12345678');
INSERT INTO `application_responses` VALUES (3, 8, 3, NULL, NULL, '2025-07-19 22:23:36', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (4, 8, 4, NULL, NULL, '2025-07-19 22:23:36', 'Emmanuel');
INSERT INTO `application_responses` VALUES (5, 8, 6, NULL, NULL, '2025-07-19 22:23:36', 'Koroma');
INSERT INTO `application_responses` VALUES (6, 8, 7, NULL, NULL, '2025-07-19 22:23:36', '2025-07-01');
INSERT INTO `application_responses` VALUES (7, 8, 9, NULL, NULL, '2025-07-19 22:23:36', 'Sierra Leonean');
INSERT INTO `application_responses` VALUES (8, 8, 10, NULL, NULL, '2025-07-19 22:23:36', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (9, 8, 12, NULL, NULL, '2025-07-19 22:23:36', '12222222');
INSERT INTO `application_responses` VALUES (10, 8, 13, NULL, NULL, '2025-07-19 22:23:36', '12212323');
INSERT INTO `application_responses` VALUES (11, 8, 8, NULL, NULL, '2025-07-19 22:23:36', 'Male');
INSERT INTO `application_responses` VALUES (12, 8, 11, NULL, NULL, '2025-07-19 22:23:36', 'Single');
INSERT INTO `application_responses` VALUES (13, 8, 14, NULL, NULL, '2025-07-19 22:23:36', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (14, 8, 16, NULL, NULL, '2025-07-19 22:23:36', 'Bo');
INSERT INTO `application_responses` VALUES (15, 8, 18, NULL, NULL, '2025-07-19 22:23:36', 'koromaemmanuel66@gmail.com');
INSERT INTO `application_responses` VALUES (16, 8, 19, NULL, NULL, '2025-07-19 22:23:36', '078618435');
INSERT INTO `application_responses` VALUES (17, 8, 20, NULL, NULL, '2025-07-19 22:23:36', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (18, 8, 15, NULL, NULL, '2025-07-19 22:23:36', 'Southern');
INSERT INTO `application_responses` VALUES (19, 8, 21, NULL, NULL, '2025-07-19 22:23:36', 'Brother');
INSERT INTO `application_responses` VALUES (20, 8, 22, NULL, NULL, '2025-07-19 22:23:36', '3434344343');
INSERT INTO `application_responses` VALUES (23, 8, 25, NULL, NULL, '2025-07-19 22:23:36', '4');
INSERT INTO `application_responses` VALUES (24, 8, 26, NULL, NULL, '2025-07-19 22:23:36', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (25, 8, 27, NULL, NULL, '2025-07-19 22:23:36', 'Certificate');
INSERT INTO `application_responses` VALUES (26, 8, 28, NULL, NULL, '2025-07-19 22:23:36', 'State Registered Nurse (SRN)');
INSERT INTO `application_responses` VALUES (27, 8, 29, NULL, NULL, '2025-07-19 22:23:36', 'Part-time');
INSERT INTO `application_responses` VALUES (28, 8, 30, NULL, NULL, '2025-07-19 22:23:36', 'ATAM.jpg');
INSERT INTO `application_responses` VALUES (29, 8, 31, NULL, NULL, '2025-07-19 22:23:36', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (30, 8, 32, NULL, NULL, '2025-07-19 22:23:36', 'Bo School appointment.jpg');
INSERT INTO `application_responses` VALUES (31, 8, 33, NULL, NULL, '2025-07-19 22:23:36', 'Bo School appointment.jpg');
INSERT INTO `application_responses` VALUES (32, 8, 34, NULL, NULL, '2025-07-19 22:23:36', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (36, 8, 38, NULL, NULL, '2025-07-19 22:23:36', 'Sponsor');
INSERT INTO `application_responses` VALUES (37, 8, 39, NULL, NULL, '2025-07-19 22:23:36', 'Abu');
INSERT INTO `application_responses` VALUES (38, 8, 40, NULL, NULL, '2025-07-19 22:23:36', 'Brother');
INSERT INTO `application_responses` VALUES (39, 8, 41, NULL, NULL, '2025-07-19 22:23:36', 'Good');
INSERT INTO `application_responses` VALUES (40, 8, 42, NULL, NULL, '2025-07-19 22:23:36', 'Social Media');
INSERT INTO `application_responses` VALUES (41, 8, 43, NULL, NULL, '2025-07-19 22:23:36', 'No');
INSERT INTO `application_responses` VALUES (42, 8, 44, NULL, NULL, '2025-07-19 22:23:36', 'No');
INSERT INTO `application_responses` VALUES (43, 8, 45, NULL, NULL, '2025-07-19 22:23:36', 'Yes');
INSERT INTO `application_responses` VALUES (44, 8, 46, NULL, NULL, '2025-07-19 22:23:36', 'Yes');
INSERT INTO `application_responses` VALUES (45, 8, 47, NULL, NULL, '2025-07-19 22:23:36', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (46, 8, 3, NULL, '2025-07-20_00-23-36_687c1ae81d7fc.png', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (47, 8, 26, NULL, '2025-07-20_00-23-36_687c1ae81f387.png', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (48, 8, 30, NULL, '2025-07-20_00-23-36_687c1ae82011f.jpg', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (49, 8, 31, NULL, '2025-07-20_00-23-36_687c1ae820d6d.png', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (50, 8, 32, NULL, '2025-07-20_00-23-36_687c1ae821966.jpg', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (51, 8, 33, NULL, '2025-07-20_00-23-36_687c1ae822556.jpg', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (52, 8, 34, NULL, '2025-07-20_00-23-36_687c1ae823083.png', '2025-07-19 22:23:36', NULL);
INSERT INTO `application_responses` VALUES (98, 10, 1, NULL, NULL, '2025-08-09 01:18:44', 'Bank Transfer');
INSERT INTO `application_responses` VALUES (99, 10, 2, NULL, NULL, '2025-08-09 01:18:44', '12345678');
INSERT INTO `application_responses` VALUES (100, 10, 3, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (101, 10, 30, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (102, 10, 31, NULL, NULL, '2025-08-09 01:18:44', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (103, 10, 32, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (104, 10, 33, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (105, 10, 34, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (106, 10, 23, NULL, NULL, '2025-08-09 01:18:44', 'WASSCE');
INSERT INTO `application_responses` VALUES (107, 10, 24, NULL, NULL, '2025-08-09 01:18:44', 'Example');
INSERT INTO `application_responses` VALUES (108, 10, 25, NULL, NULL, '2025-08-09 01:18:44', '4');
INSERT INTO `application_responses` VALUES (109, 10, 26, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (110, 10, 4, NULL, NULL, '2025-08-09 01:18:44', 'Emmanuel');
INSERT INTO `application_responses` VALUES (111, 10, 6, NULL, NULL, '2025-08-09 01:18:44', 'Koroma');
INSERT INTO `application_responses` VALUES (112, 10, 7, NULL, NULL, '2025-08-09 01:18:44', '2025-07-01');
INSERT INTO `application_responses` VALUES (113, 10, 8, NULL, NULL, '2025-08-09 01:18:44', 'Male');
INSERT INTO `application_responses` VALUES (114, 10, 9, NULL, NULL, '2025-08-09 01:18:44', 'Sierra Leonean');
INSERT INTO `application_responses` VALUES (115, 10, 10, NULL, NULL, '2025-08-09 01:18:44', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (116, 10, 11, NULL, NULL, '2025-08-09 01:18:44', 'Single');
INSERT INTO `application_responses` VALUES (117, 10, 12, NULL, NULL, '2025-08-09 01:18:44', '12222222');
INSERT INTO `application_responses` VALUES (118, 10, 13, NULL, NULL, '2025-08-09 01:18:44', '12212323');
INSERT INTO `application_responses` VALUES (119, 10, 38, NULL, NULL, '2025-08-09 01:18:44', 'Sponsor');
INSERT INTO `application_responses` VALUES (120, 10, 39, NULL, NULL, '2025-08-09 01:18:44', 'Abu');
INSERT INTO `application_responses` VALUES (121, 10, 40, NULL, NULL, '2025-08-09 01:18:44', 'Brother');
INSERT INTO `application_responses` VALUES (122, 10, 41, NULL, NULL, '2025-08-09 01:18:44', 'Good');
INSERT INTO `application_responses` VALUES (123, 10, 42, NULL, NULL, '2025-08-09 01:18:44', 'Social Media');
INSERT INTO `application_responses` VALUES (124, 10, 43, NULL, NULL, '2025-08-09 01:18:44', 'No');
INSERT INTO `application_responses` VALUES (125, 10, 44, NULL, NULL, '2025-08-09 01:18:44', 'No');
INSERT INTO `application_responses` VALUES (126, 10, 14, NULL, NULL, '2025-08-09 01:18:44', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (127, 10, 15, NULL, NULL, '2025-08-09 01:18:44', 'Southern');
INSERT INTO `application_responses` VALUES (128, 10, 16, NULL, NULL, '2025-08-09 01:18:44', 'Bo');
INSERT INTO `application_responses` VALUES (129, 10, 18, NULL, NULL, '2025-08-09 01:18:44', 'koromaemmanuel66@gmail.com');
INSERT INTO `application_responses` VALUES (130, 10, 19, NULL, NULL, '2025-08-09 01:18:44', '078618435');
INSERT INTO `application_responses` VALUES (131, 10, 20, NULL, NULL, '2025-08-09 01:18:44', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (132, 10, 21, NULL, NULL, '2025-08-09 01:18:44', 'Brother');
INSERT INTO `application_responses` VALUES (133, 10, 22, NULL, NULL, '2025-08-09 01:18:44', '3434344343');
INSERT INTO `application_responses` VALUES (134, 10, 45, NULL, NULL, '2025-08-09 01:18:44', 'Yes');
INSERT INTO `application_responses` VALUES (135, 10, 46, NULL, NULL, '2025-08-09 01:18:44', 'Yes');
INSERT INTO `application_responses` VALUES (136, 10, 47, NULL, NULL, '2025-08-09 01:18:44', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (137, 10, 27, NULL, NULL, '2025-08-09 01:18:44', 'Certificate');
INSERT INTO `application_responses` VALUES (138, 10, 28, NULL, NULL, '2025-08-09 01:18:44', 'State Registered Nurse (SRN)');
INSERT INTO `application_responses` VALUES (139, 10, 29, NULL, NULL, '2025-08-09 01:18:44', 'Part-time');
INSERT INTO `application_responses` VALUES (143, 11, 1, NULL, NULL, '2025-08-09 01:18:44', 'Bank Transfer');
INSERT INTO `application_responses` VALUES (144, 11, 2, NULL, NULL, '2025-08-09 01:18:44', '12345678');
INSERT INTO `application_responses` VALUES (145, 11, 3, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (146, 11, 30, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (147, 11, 31, NULL, NULL, '2025-08-09 01:18:44', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (148, 11, 32, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (149, 11, 33, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (150, 11, 34, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (151, 11, 23, NULL, NULL, '2025-08-09 01:18:44', 'WASSCE');
INSERT INTO `application_responses` VALUES (152, 11, 24, NULL, NULL, '2025-08-09 01:18:44', 'Example');
INSERT INTO `application_responses` VALUES (153, 11, 25, NULL, NULL, '2025-08-09 01:18:44', '4');
INSERT INTO `application_responses` VALUES (154, 11, 26, NULL, NULL, '2025-08-09 01:18:44', 'null');
INSERT INTO `application_responses` VALUES (155, 11, 4, NULL, NULL, '2025-08-09 01:18:44', 'Emmanuel');
INSERT INTO `application_responses` VALUES (156, 11, 6, NULL, NULL, '2025-08-09 01:18:44', 'Koroma');
INSERT INTO `application_responses` VALUES (157, 11, 7, NULL, NULL, '2025-08-09 01:18:44', '2025-07-01');
INSERT INTO `application_responses` VALUES (158, 11, 8, NULL, NULL, '2025-08-09 01:18:44', 'Male');
INSERT INTO `application_responses` VALUES (159, 11, 9, NULL, NULL, '2025-08-09 01:18:44', 'Sierra Leonean');
INSERT INTO `application_responses` VALUES (160, 11, 10, NULL, NULL, '2025-08-09 01:18:44', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (161, 11, 11, NULL, NULL, '2025-08-09 01:18:44', 'Single');
INSERT INTO `application_responses` VALUES (162, 11, 12, NULL, NULL, '2025-08-09 01:18:44', '12222222');
INSERT INTO `application_responses` VALUES (163, 11, 13, NULL, NULL, '2025-08-09 01:18:44', '12212323');
INSERT INTO `application_responses` VALUES (164, 11, 38, NULL, NULL, '2025-08-09 01:18:44', 'Sponsor');
INSERT INTO `application_responses` VALUES (165, 11, 39, NULL, NULL, '2025-08-09 01:18:44', 'Abu');
INSERT INTO `application_responses` VALUES (166, 11, 40, NULL, NULL, '2025-08-09 01:18:44', 'Brother');
INSERT INTO `application_responses` VALUES (167, 11, 41, NULL, NULL, '2025-08-09 01:18:44', 'Good');
INSERT INTO `application_responses` VALUES (168, 11, 42, NULL, NULL, '2025-08-09 01:18:44', 'Social Media');
INSERT INTO `application_responses` VALUES (169, 11, 43, NULL, NULL, '2025-08-09 01:18:44', 'No');
INSERT INTO `application_responses` VALUES (170, 11, 44, NULL, NULL, '2025-08-09 01:18:44', 'No');
INSERT INTO `application_responses` VALUES (171, 11, 14, NULL, NULL, '2025-08-09 01:18:44', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (172, 11, 15, NULL, NULL, '2025-08-09 01:18:44', 'Southern');
INSERT INTO `application_responses` VALUES (173, 11, 16, NULL, NULL, '2025-08-09 01:18:44', 'Bo');
INSERT INTO `application_responses` VALUES (174, 11, 18, NULL, NULL, '2025-08-09 01:18:44', 'koromaemmanuel66@gmail.com');
INSERT INTO `application_responses` VALUES (175, 11, 19, NULL, NULL, '2025-08-09 01:18:44', '078618435');
INSERT INTO `application_responses` VALUES (176, 11, 20, NULL, NULL, '2025-08-09 01:18:44', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (177, 11, 21, NULL, NULL, '2025-08-09 01:18:44', 'Brother');
INSERT INTO `application_responses` VALUES (178, 11, 22, NULL, NULL, '2025-08-09 01:18:44', '3434344343');
INSERT INTO `application_responses` VALUES (179, 11, 45, NULL, NULL, '2025-08-09 01:18:44', 'Yes');
INSERT INTO `application_responses` VALUES (180, 11, 46, NULL, NULL, '2025-08-09 01:18:44', 'Yes');
INSERT INTO `application_responses` VALUES (181, 11, 47, NULL, NULL, '2025-08-09 01:18:44', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (182, 11, 27, NULL, NULL, '2025-08-09 01:18:44', 'Certificate');
INSERT INTO `application_responses` VALUES (183, 11, 28, NULL, NULL, '2025-08-09 01:18:44', 'State Registered Nurse (SRN)');
INSERT INTO `application_responses` VALUES (184, 11, 29, NULL, NULL, '2025-08-09 01:18:44', 'Part-time');
INSERT INTO `application_responses` VALUES (188, 12, 1, NULL, NULL, '2025-08-13 10:05:39', 'Bank Transfer');
INSERT INTO `application_responses` VALUES (189, 12, 2, NULL, NULL, '2025-08-13 10:05:39', '12345678');
INSERT INTO `application_responses` VALUES (190, 12, 3, NULL, NULL, '2025-08-13 10:05:39', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (191, 12, 4, NULL, NULL, '2025-08-13 10:05:39', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (192, 12, 5, NULL, NULL, '2025-08-13 10:05:39', 'Mariama');
INSERT INTO `application_responses` VALUES (193, 12, 6, NULL, NULL, '2025-08-13 10:05:39', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (194, 12, 7, NULL, NULL, '2025-08-13 10:05:39', '2025-08-13');
INSERT INTO `application_responses` VALUES (195, 12, 9, NULL, NULL, '2025-08-13 10:05:39', 'Sierra Leonean');
INSERT INTO `application_responses` VALUES (196, 12, 10, NULL, NULL, '2025-08-13 10:05:39', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (197, 12, 8, NULL, NULL, '2025-08-13 10:05:39', 'Male');
INSERT INTO `application_responses` VALUES (198, 12, 11, NULL, NULL, '2025-08-13 10:05:39', 'Single');
INSERT INTO `application_responses` VALUES (199, 12, 13, NULL, NULL, '2025-08-13 10:05:39', '12345658');
INSERT INTO `application_responses` VALUES (200, 12, 14, NULL, NULL, '2025-08-13 10:05:39', 'Sierra Leone');
INSERT INTO `application_responses` VALUES (201, 12, 16, NULL, NULL, '2025-08-13 10:05:39', 'Bo');
INSERT INTO `application_responses` VALUES (202, 12, 18, NULL, NULL, '2025-08-13 10:05:39', 'koromaemmanuel66@gmail.com');
INSERT INTO `application_responses` VALUES (203, 12, 19, NULL, NULL, '2025-08-13 10:05:39', '078618435');
INSERT INTO `application_responses` VALUES (204, 12, 20, NULL, NULL, '2025-08-13 10:05:39', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (205, 12, 21, NULL, NULL, '2025-08-13 10:05:39', 'Brother');
INSERT INTO `application_responses` VALUES (206, 12, 22, NULL, NULL, '2025-08-13 10:05:39', '078618435');
INSERT INTO `application_responses` VALUES (207, 12, 15, NULL, NULL, '2025-08-13 10:05:39', 'Southern');
INSERT INTO `application_responses` VALUES (208, 12, 23, NULL, NULL, '2025-08-13 10:05:39', 'WASSCE');
INSERT INTO `application_responses` VALUES (209, 12, 26, NULL, NULL, '2025-08-13 10:05:39', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (210, 12, 27, NULL, NULL, '2025-08-13 10:05:39', 'Certificate');
INSERT INTO `application_responses` VALUES (211, 12, 28, NULL, NULL, '2025-08-13 10:05:39', 'State Registered Nurse (SRN)');
INSERT INTO `application_responses` VALUES (212, 12, 29, NULL, NULL, '2025-08-13 10:05:39', 'Part-time');
INSERT INTO `application_responses` VALUES (213, 12, 30, NULL, NULL, '2025-08-13 10:05:39', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (214, 12, 31, NULL, NULL, '2025-08-13 10:05:39', 'Bo School appointment.jpg');
INSERT INTO `application_responses` VALUES (215, 12, 32, NULL, NULL, '2025-08-13 10:05:39', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (216, 12, 33, NULL, NULL, '2025-08-13 10:05:39', 'Bo School appointment.jpg');
INSERT INTO `application_responses` VALUES (217, 12, 34, NULL, NULL, '2025-08-13 10:05:39', 'anomaly_detection.png');
INSERT INTO `application_responses` VALUES (221, 12, 38, NULL, NULL, '2025-08-13 10:05:39', 'Sponsor');
INSERT INTO `application_responses` VALUES (222, 12, 39, NULL, NULL, '2025-08-13 10:05:39', 'Abu');
INSERT INTO `application_responses` VALUES (223, 12, 41, NULL, NULL, '2025-08-13 10:05:39', 'Online');
INSERT INTO `application_responses` VALUES (224, 12, 42, NULL, NULL, '2025-08-13 10:05:39', 'Social Media');
INSERT INTO `application_responses` VALUES (225, 12, 43, NULL, NULL, '2025-08-13 10:05:39', 'No');
INSERT INTO `application_responses` VALUES (226, 12, 44, NULL, NULL, '2025-08-13 10:05:39', 'No');
INSERT INTO `application_responses` VALUES (227, 12, 45, NULL, NULL, '2025-08-13 10:05:39', 'Yes');
INSERT INTO `application_responses` VALUES (228, 12, 46, NULL, NULL, '2025-08-13 10:05:39', 'Yes');
INSERT INTO `application_responses` VALUES (229, 12, 47, NULL, NULL, '2025-08-13 10:05:39', 'Emmanuel Koroma');
INSERT INTO `application_responses` VALUES (230, 12, 3, NULL, '2025-08-13_12-05-40_689c637402586.png', '2025-08-13 10:05:40', NULL);
INSERT INTO `application_responses` VALUES (231, 12, 26, NULL, '2025-08-13_12-05-40_689c637405781.png', '2025-08-13 10:05:40', NULL);
INSERT INTO `application_responses` VALUES (232, 12, 30, NULL, '2025-08-13_12-05-40_689c6374065b6.png', '2025-08-13 10:05:40', NULL);
INSERT INTO `application_responses` VALUES (233, 12, 31, NULL, '2025-08-13_12-05-40_689c63740755f.jpg', '2025-08-13 10:05:40', NULL);
INSERT INTO `application_responses` VALUES (234, 12, 32, NULL, '2025-08-13_12-05-40_689c637408004.png', '2025-08-13 10:05:40', NULL);
INSERT INTO `application_responses` VALUES (235, 12, 33, NULL, '2025-08-13_12-05-40_689c637408a89.jpg', '2025-08-13 10:05:40', NULL);
INSERT INTO `application_responses` VALUES (236, 12, 34, NULL, '2025-08-13_12-05-40_689c63740949b.png', '2025-08-13 10:05:40', NULL);

-- ----------------------------
-- Table structure for applications
-- ----------------------------
DROP TABLE IF EXISTS `applications`;
CREATE TABLE `applications`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicant_id` int NULL DEFAULT NULL,
  `program_type` enum('undergraduate','diploma') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `application_status` enum('draft','submitted','under_review','interview_scheduled','offer_issued','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft',
  `form_data` json NULL,
  `submission_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `applicant_id`(`applicant_id` ASC) USING BTREE,
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`applicant_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of applications
-- ----------------------------
INSERT INTO `applications` VALUES (2, 4, 'diploma', 'draft', 'null', '2025-06-11 02:15:32', '2025-07-19 03:15:38', '2025-07-19 03:16:45', 0, 'draft');
INSERT INTO `applications` VALUES (3, 4, 'diploma', 'draft', 'null', '2025-06-13 14:04:00', '2025-07-19 03:15:38', '2025-07-19 03:16:45', 0, 'draft');
INSERT INTO `applications` VALUES (8, NULL, NULL, 'submitted', NULL, NULL, '2025-07-19 22:23:36', '2025-07-19 22:23:36', 4, 'draft');
INSERT INTO `applications` VALUES (10, NULL, NULL, 'submitted', NULL, NULL, '2025-08-09 01:18:44', '2025-08-09 01:18:44', 4, 'draft');
INSERT INTO `applications` VALUES (11, NULL, NULL, 'submitted', NULL, NULL, '2025-08-09 01:18:44', '2025-08-09 01:18:44', 4, 'draft');
INSERT INTO `applications` VALUES (12, NULL, NULL, 'submitted', NULL, NULL, '2025-08-13 10:05:39', '2025-08-13 10:05:39', 7, 'draft');

-- ----------------------------
-- Table structure for audit_logs
-- ----------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `details` json NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `form_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 917 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of audit_logs
-- ----------------------------
INSERT INTO `audit_logs` VALUES (1, NULL, 'create_application', '{\"application_id\": 1}', '2025-06-11 02:12:20', NULL);
INSERT INTO `audit_logs` VALUES (2, 4, 'create_application', '{\"application_id\": 2}', '2025-06-11 02:15:32', NULL);
INSERT INTO `audit_logs` VALUES (3, 4, 'create_application', '{\"application_id\": 3}', '2025-06-13 14:04:00', NULL);
INSERT INTO `audit_logs` VALUES (4, 4, 'save_application_progress', '{\"step\": \"0\"}', '2025-07-19 04:06:22', NULL);
INSERT INTO `audit_logs` VALUES (5, 4, 'save_application_progress', '{\"step\": \"1\"}', '2025-07-19 04:06:55', NULL);
INSERT INTO `audit_logs` VALUES (6, 4, 'save_application_progress', '{\"step\": \"2\"}', '2025-07-19 04:07:20', NULL);
INSERT INTO `audit_logs` VALUES (7, 4, 'save_application_progress', '{\"step\": \"3\"}', '2025-07-19 04:07:51', NULL);
INSERT INTO `audit_logs` VALUES (8, 4, 'save_application_progress', '{\"step\": \"4\"}', '2025-07-19 04:08:06', NULL);
INSERT INTO `audit_logs` VALUES (9, 4, 'save_application_progress', '{\"step\": \"5\"}', '2025-07-19 04:08:54', NULL);
INSERT INTO `audit_logs` VALUES (10, 4, 'save_application_progress', '{\"step\": \"5\"}', '2025-07-19 04:09:04', NULL);
INSERT INTO `audit_logs` VALUES (11, 4, 'save_application_progress', '{\"step\": \"5\"}', '2025-07-19 04:13:44', NULL);
INSERT INTO `audit_logs` VALUES (12, 4, 'save_application_progress', '{\"step\": \"6\"}', '2025-07-19 04:14:24', NULL);
INSERT INTO `audit_logs` VALUES (13, 4, 'save_application_progress', '{\"step\": \"7\"}', '2025-07-19 04:14:37', NULL);
INSERT INTO `audit_logs` VALUES (14, 4, 'save_application_progress', '{\"step\": \"8\"}', '2025-07-19 04:14:57', NULL);
INSERT INTO `audit_logs` VALUES (15, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:15:36', NULL);
INSERT INTO `audit_logs` VALUES (16, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:16:06', NULL);
INSERT INTO `audit_logs` VALUES (17, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:16:36', NULL);
INSERT INTO `audit_logs` VALUES (18, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:17:06', NULL);
INSERT INTO `audit_logs` VALUES (19, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:17:36', NULL);
INSERT INTO `audit_logs` VALUES (20, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:18:06', NULL);
INSERT INTO `audit_logs` VALUES (21, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:18:53', NULL);
INSERT INTO `audit_logs` VALUES (22, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:19:09', NULL);
INSERT INTO `audit_logs` VALUES (23, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:20:09', NULL);
INSERT INTO `audit_logs` VALUES (24, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:20:48', NULL);
INSERT INTO `audit_logs` VALUES (25, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:21:06', NULL);
INSERT INTO `audit_logs` VALUES (26, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:21:36', NULL);
INSERT INTO `audit_logs` VALUES (27, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:22:09', NULL);
INSERT INTO `audit_logs` VALUES (28, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:23:09', NULL);
INSERT INTO `audit_logs` VALUES (29, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:24:09', NULL);
INSERT INTO `audit_logs` VALUES (30, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:25:09', NULL);
INSERT INTO `audit_logs` VALUES (31, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:27:24', NULL);
INSERT INTO `audit_logs` VALUES (32, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:27:54', NULL);
INSERT INTO `audit_logs` VALUES (33, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:28:24', NULL);
INSERT INTO `audit_logs` VALUES (34, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:28:54', NULL);
INSERT INTO `audit_logs` VALUES (35, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:29:24', NULL);
INSERT INTO `audit_logs` VALUES (36, 4, 'save_application_progress', '{\"step\": \"9\"}', '2025-07-19 04:29:54', NULL);
INSERT INTO `audit_logs` VALUES (37, 4, 'save_application_progress', NULL, '2025-07-19 13:32:06', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (38, 4, 'save_application_progress', NULL, '2025-07-19 13:39:57', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (39, 4, 'save_application_progress', NULL, '2025-07-19 13:40:01', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (40, 4, 'save_application_progress', NULL, '2025-07-19 13:40:34', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (41, 4, 'save_application_progress', NULL, '2025-07-19 13:41:02', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (42, 4, 'save_application_progress', NULL, '2025-07-19 13:41:45', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (43, 4, 'save_application_progress', NULL, '2025-07-19 13:42:03', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (44, 4, 'save_application_progress', NULL, '2025-07-19 13:42:39', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (45, 4, 'save_application_progress', NULL, '2025-07-19 13:42:44', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (46, 4, 'save_application_progress', NULL, '2025-07-19 13:42:55', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (47, 4, 'save_application_progress', NULL, '2025-07-19 13:43:10', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (48, 4, 'save_application_progress', NULL, '2025-07-19 13:43:24', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (49, 4, 'save_application_progress', NULL, '2025-07-19 13:43:40', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (50, 4, 'save_application_progress', NULL, '2025-07-19 13:43:55', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (51, 4, 'save_application_progress', NULL, '2025-07-19 13:44:15', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (52, 4, 'save_application_progress', NULL, '2025-07-19 13:44:24', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (53, 4, 'save_application_progress', NULL, '2025-07-19 13:44:33', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (54, 4, 'save_application_progress', NULL, '2025-07-19 13:44:49', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (55, 4, 'save_application_progress', NULL, '2025-07-19 13:45:06', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (56, 4, 'save_application_progress', NULL, '2025-07-19 13:45:49', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (57, 4, 'save_application_progress', NULL, '2025-07-19 13:46:18', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (58, 4, 'save_application_progress', NULL, '2025-07-19 13:46:48', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (59, 4, 'save_application_progress', NULL, '2025-07-19 13:47:18', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (60, 4, 'save_application_progress', NULL, '2025-07-19 13:47:48', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (61, 4, 'save_application_progress', NULL, '2025-07-19 13:48:18', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (62, 4, 'save_application_progress', NULL, '2025-07-19 13:49:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (63, 4, 'save_application_progress', NULL, '2025-07-19 13:50:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (64, 4, 'save_application_progress', NULL, '2025-07-19 13:53:35', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (65, 4, 'save_application_progress', NULL, '2025-07-19 21:53:42', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (66, 4, 'save_application_progress', NULL, '2025-07-19 21:53:54', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (67, 4, 'save_application_progress', NULL, '2025-07-19 21:56:20', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (68, 4, 'save_application_progress', NULL, '2025-07-19 21:57:22', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (69, 4, 'save_application_progress', NULL, '2025-07-19 21:57:55', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (70, 4, 'save_application_progress', NULL, '2025-07-19 21:58:30', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (71, 4, 'save_application_progress', NULL, '2025-07-19 21:58:43', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (72, 4, 'save_application_progress', NULL, '2025-07-19 21:59:17', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (73, 4, 'save_application_progress', NULL, '2025-07-19 21:59:27', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (74, 4, 'save_application_progress', NULL, '2025-07-19 21:59:35', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (75, 4, 'save_application_progress', NULL, '2025-07-19 21:59:45', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (76, 4, 'save_application_progress', NULL, '2025-07-19 21:59:55', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (77, 4, 'save_application_progress', NULL, '2025-07-19 21:59:59', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (78, 4, 'save_application_progress', NULL, '2025-07-19 22:00:07', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (79, 4, 'save_application_progress', NULL, '2025-07-19 22:00:19', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (80, 4, 'save_application_progress', NULL, '2025-07-19 22:00:35', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (81, 4, 'save_application_progress', NULL, '2025-07-19 22:01:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (82, 4, 'save_application_progress', NULL, '2025-07-19 22:01:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (83, 4, 'save_application_progress', NULL, '2025-07-19 22:02:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (84, 4, 'save_application_progress', NULL, '2025-07-19 22:02:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (85, 4, 'save_application_progress', NULL, '2025-07-19 22:03:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (86, 4, 'save_application_progress', NULL, '2025-07-19 22:03:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (87, 4, 'save_application_progress', NULL, '2025-07-19 22:04:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (88, 4, 'save_application_progress', NULL, '2025-07-19 22:04:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (89, 4, 'save_application_progress', NULL, '2025-07-19 22:06:01', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (90, 4, 'save_application_progress', NULL, '2025-07-19 22:06:27', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (91, 4, 'save_application_progress', NULL, '2025-07-19 22:06:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (92, 4, 'save_application_progress', NULL, '2025-07-19 22:07:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (93, 4, 'save_application_progress', NULL, '2025-07-19 22:07:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (94, 4, 'save_application_progress', NULL, '2025-07-19 22:09:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (95, 4, 'save_application_progress', NULL, '2025-07-19 22:10:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (96, 4, 'save_application_progress', NULL, '2025-07-19 22:11:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (97, 4, 'save_application_progress', NULL, '2025-07-19 22:12:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (98, 4, 'save_application_progress', NULL, '2025-07-19 22:13:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (99, 4, 'save_application_progress', NULL, '2025-07-19 22:14:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (100, 4, 'save_application_progress', NULL, '2025-07-19 22:15:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (101, 4, 'save_application_progress', NULL, '2025-07-19 22:16:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (102, 4, 'save_application_progress', NULL, '2025-07-19 22:17:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (103, 4, 'save_application_progress', NULL, '2025-07-19 22:18:11', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (104, 4, 'save_application_progress', NULL, '2025-07-19 22:19:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (105, 4, 'save_application_progress', NULL, '2025-07-19 22:19:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (106, 4, 'save_application_progress', NULL, '2025-07-19 22:20:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (107, 4, 'save_application_progress', NULL, '2025-07-19 22:20:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (108, 4, 'save_application_progress', NULL, '2025-07-19 22:21:36', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (109, 4, 'save_application_progress', NULL, '2025-07-19 22:21:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (110, 4, 'save_application_progress', NULL, '2025-07-19 22:22:13', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (111, 4, 'save_application_progress', NULL, '2025-07-19 22:23:10', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (112, 4, 'save_application_progress', NULL, '2025-07-19 22:23:31', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (113, 4, 'save_application_progress', NULL, '2025-07-19 22:23:43', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (114, 4, 'create_payment', NULL, '2025-08-07 00:28:20', '{\"payment_id\":5,\"amount\":500}');
INSERT INTO `audit_logs` VALUES (115, 4, 'save_application_progress', NULL, '2025-08-09 01:16:40', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (116, 4, 'save_application_progress', NULL, '2025-08-09 01:16:45', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (117, 4, 'save_application_progress', NULL, '2025-08-09 01:16:50', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (118, 4, 'save_application_progress', NULL, '2025-08-09 01:17:15', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (119, 4, 'save_application_progress', NULL, '2025-08-09 01:17:26', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (120, 4, 'save_application_progress', NULL, '2025-08-09 01:17:45', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (121, 4, 'save_application_progress', NULL, '2025-08-09 01:17:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (122, 4, 'save_application_progress', NULL, '2025-08-09 01:18:07', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (123, 4, 'save_application_progress', NULL, '2025-08-09 01:18:34', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (124, 7, 'save_application_progress', NULL, '2025-08-09 10:15:29', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (125, 7, 'save_application_progress', NULL, '2025-08-09 10:15:35', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (126, 7, 'save_application_progress', NULL, '2025-08-09 10:16:40', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (127, 7, 'save_application_progress', NULL, '2025-08-09 10:17:10', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (128, 7, 'save_application_progress', NULL, '2025-08-09 10:17:40', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (129, 7, 'save_application_progress', NULL, '2025-08-09 10:18:10', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (130, 7, 'save_application_progress', NULL, '2025-08-09 10:18:40', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (131, 7, 'save_application_progress', NULL, '2025-08-09 10:19:10', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (132, 7, 'save_application_progress', NULL, '2025-08-09 10:19:40', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (133, 7, 'save_application_progress', NULL, '2025-08-09 10:20:11', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (134, 7, 'save_application_progress', NULL, '2025-08-09 10:20:41', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (135, 7, 'save_application_progress', NULL, '2025-08-09 10:21:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (136, 7, 'save_application_progress', NULL, '2025-08-09 10:22:00', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (137, 7, 'save_application_progress', NULL, '2025-08-09 10:22:10', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (138, 7, 'save_application_progress', NULL, '2025-08-09 10:22:40', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (139, 7, 'save_application_progress', NULL, '2025-08-09 10:23:11', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (140, 7, 'save_application_progress', NULL, '2025-08-09 10:23:41', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (141, 7, 'save_application_progress', NULL, '2025-08-09 10:24:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (142, 7, 'save_application_progress', NULL, '2025-08-09 10:25:27', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (143, 7, 'save_application_progress', NULL, '2025-08-09 10:26:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (144, 7, 'save_application_progress', NULL, '2025-08-09 10:27:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (145, 7, 'save_application_progress', NULL, '2025-08-09 10:28:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (146, 7, 'save_application_progress', NULL, '2025-08-09 10:29:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (147, 7, 'save_application_progress', NULL, '2025-08-09 10:30:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (148, 7, 'save_application_progress', NULL, '2025-08-09 10:31:27', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (149, 7, 'save_application_progress', NULL, '2025-08-09 10:32:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (150, 7, 'save_application_progress', NULL, '2025-08-09 10:33:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (151, 7, 'save_application_progress', NULL, '2025-08-09 10:34:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (152, 7, 'save_application_progress', NULL, '2025-08-09 10:35:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (153, 7, 'save_application_progress', NULL, '2025-08-09 10:36:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (154, 7, 'save_application_progress', NULL, '2025-08-09 10:37:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (155, 7, 'save_application_progress', NULL, '2025-08-09 10:38:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (156, 7, 'save_application_progress', NULL, '2025-08-09 10:39:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (157, 7, 'save_application_progress', NULL, '2025-08-09 10:41:24', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (158, 7, 'save_application_progress', NULL, '2025-08-09 10:41:28', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (159, 7, 'save_application_progress', NULL, '2025-08-09 10:43:47', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (160, 7, 'save_application_progress', NULL, '2025-08-09 10:44:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (161, 7, 'save_application_progress', NULL, '2025-08-09 10:45:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (162, 7, 'save_application_progress', NULL, '2025-08-09 10:45:51', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (163, 7, 'save_application_progress', NULL, '2025-08-09 10:46:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (164, 7, 'save_application_progress', NULL, '2025-08-09 10:47:23', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (165, 7, 'save_application_progress', NULL, '2025-08-09 10:47:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (166, 7, 'save_application_progress', NULL, '2025-08-09 10:47:54', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (167, 7, 'save_application_progress', NULL, '2025-08-09 10:48:24', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (168, 7, 'save_application_progress', NULL, '2025-08-09 10:48:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (169, 7, 'save_application_progress', NULL, '2025-08-09 10:48:37', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (170, 7, 'save_application_progress', NULL, '2025-08-09 10:49:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (171, 7, 'save_application_progress', NULL, '2025-08-09 10:50:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (172, 7, 'save_application_progress', NULL, '2025-08-09 10:51:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (173, 7, 'save_application_progress', NULL, '2025-08-09 10:52:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (174, 7, 'save_application_progress', NULL, '2025-08-09 10:52:34', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (175, 7, 'save_application_progress', NULL, '2025-08-09 10:53:04', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (176, 7, 'save_application_progress', NULL, '2025-08-09 10:53:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (177, 7, 'save_application_progress', NULL, '2025-08-09 10:53:34', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (178, 7, 'save_application_progress', NULL, '2025-08-09 10:54:04', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (179, 7, 'save_application_progress', NULL, '2025-08-09 10:54:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (180, 7, 'save_application_progress', NULL, '2025-08-09 10:54:34', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (181, 7, 'save_application_progress', NULL, '2025-08-09 10:55:04', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (182, 7, 'save_application_progress', NULL, '2025-08-09 10:55:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (183, 7, 'save_application_progress', NULL, '2025-08-09 10:56:01', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (184, 7, 'save_application_progress', NULL, '2025-08-09 10:56:05', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (185, 7, 'save_application_progress', NULL, '2025-08-09 10:56:09', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (186, 7, 'save_application_progress', NULL, '2025-08-09 10:56:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (187, 7, 'save_application_progress', NULL, '2025-08-09 10:56:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (188, 7, 'save_application_progress', NULL, '2025-08-09 10:56:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (189, 7, 'save_application_progress', NULL, '2025-08-09 10:57:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (190, 7, 'save_application_progress', NULL, '2025-08-09 10:57:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (191, 7, 'save_application_progress', NULL, '2025-08-09 10:57:56', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (192, 7, 'save_application_progress', NULL, '2025-08-09 10:58:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (193, 7, 'save_application_progress', NULL, '2025-08-09 10:58:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (194, 7, 'save_application_progress', NULL, '2025-08-09 10:59:04', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (195, 7, 'save_application_progress', NULL, '2025-08-09 10:59:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (196, 7, 'save_application_progress', NULL, '2025-08-09 10:59:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (197, 7, 'save_application_progress', NULL, '2025-08-09 11:00:04', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (198, 7, 'save_application_progress', NULL, '2025-08-09 11:00:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (199, 7, 'save_application_progress', NULL, '2025-08-09 11:00:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (200, 7, 'save_application_progress', NULL, '2025-08-09 11:01:04', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (201, 7, 'save_application_progress', NULL, '2025-08-09 11:01:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (202, 7, 'save_application_progress', NULL, '2025-08-09 11:01:36', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (203, 7, 'save_application_progress', NULL, '2025-08-09 11:02:06', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (204, 7, 'save_application_progress', NULL, '2025-08-09 11:02:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (205, 7, 'save_application_progress', NULL, '2025-08-09 11:03:24', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (206, 7, 'save_application_progress', NULL, '2025-08-09 11:03:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (207, 7, 'save_application_progress', NULL, '2025-08-09 11:04:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (208, 7, 'save_application_progress', NULL, '2025-08-09 11:04:26', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (209, 7, 'save_application_progress', NULL, '2025-08-09 11:05:25', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (210, 7, 'save_application_progress', NULL, '2025-08-09 11:05:26', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (211, 7, 'save_application_progress', NULL, '2025-08-09 11:06:26', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (212, 7, 'save_application_progress', NULL, '2025-08-09 11:06:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (213, 7, 'save_application_progress', NULL, '2025-08-09 11:07:26', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (214, 7, 'save_application_progress', NULL, '2025-08-09 11:07:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (215, 7, 'save_application_progress', NULL, '2025-08-09 11:07:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (216, 7, 'save_application_progress', NULL, '2025-08-09 11:07:41', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (217, 7, 'save_application_progress', NULL, '2025-08-09 11:07:49', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (218, 7, 'save_application_progress', NULL, '2025-08-09 11:08:04', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (219, 7, 'save_application_progress', NULL, '2025-08-09 11:08:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (220, 7, 'save_application_progress', NULL, '2025-08-09 11:08:27', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (221, 7, 'save_application_progress', NULL, '2025-08-09 11:08:40', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (222, 7, 'save_application_progress', NULL, '2025-08-09 11:09:09', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (223, 7, 'save_application_progress', NULL, '2025-08-09 11:09:19', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (224, 7, 'save_application_progress', NULL, '2025-08-09 11:09:22', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (225, 7, 'save_application_progress', NULL, '2025-08-09 11:09:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (226, 7, 'save_application_progress', NULL, '2025-08-09 11:10:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (227, 7, 'save_application_progress', NULL, '2025-08-09 11:10:27', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (228, 7, 'save_application_progress', NULL, '2025-08-09 11:10:57', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (229, 7, 'save_application_progress', NULL, '2025-08-09 11:11:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (230, 7, 'save_application_progress', NULL, '2025-08-09 11:11:27', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (231, 7, 'save_application_progress', NULL, '2025-08-09 11:11:57', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (232, 7, 'save_application_progress', NULL, '2025-08-09 11:12:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (233, 7, 'save_application_progress', NULL, '2025-08-09 11:12:27', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (234, 7, 'save_application_progress', NULL, '2025-08-09 11:12:57', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (235, 7, 'save_application_progress', NULL, '2025-08-09 11:13:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (236, 7, 'save_application_progress', NULL, '2025-08-09 11:13:35', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (237, 7, 'save_application_progress', NULL, '2025-08-09 11:13:37', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (238, 7, 'save_application_progress', NULL, '2025-08-09 11:14:17', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (239, 7, 'save_application_progress', NULL, '2025-08-09 11:14:18', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (240, 7, 'save_application_progress', NULL, '2025-08-09 11:14:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (241, 7, 'save_application_progress', NULL, '2025-08-09 11:52:05', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (242, 7, 'save_application_progress', NULL, '2025-08-09 11:52:07', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (243, 7, 'save_application_progress', NULL, '2025-08-09 11:52:31', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (244, 7, 'save_application_progress', NULL, '2025-08-09 11:53:04', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (245, 7, 'save_application_progress', NULL, '2025-08-09 11:54:29', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (246, 7, 'save_application_progress', NULL, '2025-08-09 11:54:31', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (247, 7, 'save_application_progress', NULL, '2025-08-09 11:54:42', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (248, 7, 'save_application_progress', NULL, '2025-08-09 11:54:59', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (249, 7, 'save_application_progress', NULL, '2025-08-09 11:55:38', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (250, 7, 'save_application_progress', NULL, '2025-08-09 11:56:08', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (251, 7, 'save_application_progress', NULL, '2025-08-09 11:56:38', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (252, 7, 'save_application_progress', NULL, '2025-08-09 11:57:08', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (253, 7, 'save_application_progress', NULL, '2025-08-09 11:57:38', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (254, 7, 'save_application_progress', NULL, '2025-08-09 11:58:08', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (255, 7, 'save_application_progress', NULL, '2025-08-09 11:59:40', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (256, 7, 'save_application_progress', NULL, '2025-08-09 11:59:41', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (257, 7, 'save_application_progress', NULL, '2025-08-09 12:00:01', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (258, 7, 'save_application_progress', NULL, '2025-08-09 12:00:19', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (259, 7, 'save_application_progress', NULL, '2025-08-09 12:00:54', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (260, 7, 'save_application_progress', NULL, '2025-08-09 12:01:24', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (261, 7, 'save_application_progress', NULL, '2025-08-09 12:02:14', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (262, 7, 'save_application_progress', NULL, '2025-08-09 12:02:16', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (263, 7, 'save_application_progress', NULL, '2025-08-09 12:02:56', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (264, 7, 'save_application_progress', NULL, '2025-08-09 12:03:22', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (265, 7, 'save_application_progress', NULL, '2025-08-12 21:41:41', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (266, 7, 'save_application_progress', NULL, '2025-08-12 21:41:47', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (267, 7, 'save_application_progress', NULL, '2025-08-12 21:42:18', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (268, 7, 'save_application_progress', NULL, '2025-08-12 21:55:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (269, 7, 'save_application_progress', NULL, '2025-08-12 21:55:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (270, 7, 'save_application_progress', NULL, '2025-08-12 21:56:19', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (271, 7, 'save_application_progress', NULL, '2025-08-12 21:56:45', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (272, 7, 'save_application_progress', NULL, '2025-08-12 21:57:24', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (273, 7, 'save_application_progress', NULL, '2025-08-12 21:57:55', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (274, 7, 'save_application_progress', NULL, '2025-08-12 21:58:25', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (275, 7, 'save_application_progress', NULL, '2025-08-12 21:58:54', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (276, 7, 'save_application_progress', NULL, '2025-08-12 21:59:31', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (277, 7, 'save_application_progress', NULL, '2025-08-12 22:00:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (278, 7, 'save_application_progress', NULL, '2025-08-12 22:00:31', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (279, 7, 'save_application_progress', NULL, '2025-08-12 22:01:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (280, 7, 'save_application_progress', NULL, '2025-08-12 22:01:31', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (281, 7, 'save_application_progress', NULL, '2025-08-12 22:02:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (282, 7, 'save_application_progress', NULL, '2025-08-12 22:02:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (283, 7, 'save_application_progress', NULL, '2025-08-12 22:03:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (284, 7, 'save_application_progress', NULL, '2025-08-12 22:05:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (285, 7, 'save_application_progress', NULL, '2025-08-12 22:06:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (286, 7, 'save_application_progress', NULL, '2025-08-12 22:06:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (287, 7, 'save_application_progress', NULL, '2025-08-12 22:07:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (288, 7, 'save_application_progress', NULL, '2025-08-12 22:09:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (289, 7, 'save_application_progress', NULL, '2025-08-12 22:09:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (290, 7, 'save_application_progress', NULL, '2025-08-12 22:10:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (291, 7, 'save_application_progress', NULL, '2025-08-12 22:11:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (292, 7, 'save_application_progress', NULL, '2025-08-12 22:12:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (293, 7, 'save_application_progress', NULL, '2025-08-12 22:13:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (294, 7, 'save_application_progress', NULL, '2025-08-12 22:14:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (295, 7, 'save_application_progress', NULL, '2025-08-12 22:15:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (296, 7, 'save_application_progress', NULL, '2025-08-12 22:16:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (297, 7, 'save_application_progress', NULL, '2025-08-12 22:17:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (298, 7, 'save_application_progress', NULL, '2025-08-12 22:18:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (299, 7, 'save_application_progress', NULL, '2025-08-12 22:19:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (300, 7, 'save_application_progress', NULL, '2025-08-12 22:20:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (301, 7, 'save_application_progress', NULL, '2025-08-12 22:21:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (302, 7, 'save_application_progress', NULL, '2025-08-12 22:22:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (303, 7, 'save_application_progress', NULL, '2025-08-12 22:23:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (304, 7, 'save_application_progress', NULL, '2025-08-12 22:24:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (305, 7, 'save_application_progress', NULL, '2025-08-12 22:25:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (306, 7, 'save_application_progress', NULL, '2025-08-12 22:26:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (307, 7, 'save_application_progress', NULL, '2025-08-12 22:27:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (308, 7, 'save_application_progress', NULL, '2025-08-12 22:28:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (309, 7, 'save_application_progress', NULL, '2025-08-12 22:29:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (310, 7, 'save_application_progress', NULL, '2025-08-12 22:30:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (311, 7, 'save_application_progress', NULL, '2025-08-12 22:31:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (312, 7, 'save_application_progress', NULL, '2025-08-12 22:32:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (313, 7, 'save_application_progress', NULL, '2025-08-12 22:33:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (314, 7, 'save_application_progress', NULL, '2025-08-12 22:34:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (315, 7, 'save_application_progress', NULL, '2025-08-12 22:35:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (316, 7, 'save_application_progress', NULL, '2025-08-12 22:36:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (317, 7, 'save_application_progress', NULL, '2025-08-12 22:38:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (318, 7, 'save_application_progress', NULL, '2025-08-12 22:38:57', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (319, 7, 'save_application_progress', NULL, '2025-08-12 22:39:06', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (320, 7, 'save_application_progress', NULL, '2025-08-12 22:39:11', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (321, 7, 'save_application_progress', NULL, '2025-08-13 07:42:02', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (322, 7, 'save_application_progress', NULL, '2025-08-13 07:42:06', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (323, 7, 'save_application_progress', NULL, '2025-08-13 07:42:21', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (324, 7, 'save_application_progress', NULL, '2025-08-13 07:42:44', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (325, 7, 'save_application_progress', NULL, '2025-08-13 07:43:19', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (326, 7, 'save_application_progress', NULL, '2025-08-13 07:43:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (327, 7, 'save_application_progress', NULL, '2025-08-13 07:44:18', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (328, 7, 'save_application_progress', NULL, '2025-08-13 07:44:47', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (329, 7, 'save_application_progress', NULL, '2025-08-13 07:45:17', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (330, 7, 'save_application_progress', NULL, '2025-08-13 07:45:47', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (331, 7, 'save_application_progress', NULL, '2025-08-13 07:47:14', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (332, 7, 'save_application_progress', NULL, '2025-08-13 07:48:14', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (333, 7, 'save_application_progress', NULL, '2025-08-13 07:48:35', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (334, 7, 'save_application_progress', NULL, '2025-08-13 07:48:39', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (335, 7, 'save_application_progress', NULL, '2025-08-13 07:48:56', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (336, 7, 'save_application_progress', NULL, '2025-08-13 07:49:33', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (337, 7, 'save_application_progress', NULL, '2025-08-13 07:49:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (338, 7, 'save_application_progress', NULL, '2025-08-13 07:50:45', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (339, 7, 'save_application_progress', NULL, '2025-08-13 07:51:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (340, 7, 'save_application_progress', NULL, '2025-08-13 07:51:16', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (341, 7, 'save_application_progress', NULL, '2025-08-13 07:52:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (342, 7, 'save_application_progress', NULL, '2025-08-13 07:52:43', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (343, 7, 'save_application_progress', NULL, '2025-08-13 07:53:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (344, 7, 'save_application_progress', NULL, '2025-08-13 07:53:33', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (345, 7, 'save_application_progress', NULL, '2025-08-13 07:53:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (346, 7, 'save_application_progress', NULL, '2025-08-13 07:54:12', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (347, 7, 'save_application_progress', NULL, '2025-08-13 07:54:39', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (348, 7, 'save_application_progress', NULL, '2025-08-13 07:54:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (349, 7, 'save_application_progress', NULL, '2025-08-13 07:55:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (350, 7, 'save_application_progress', NULL, '2025-08-13 07:55:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (351, 7, 'save_application_progress', NULL, '2025-08-13 07:56:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (352, 7, 'save_application_progress', NULL, '2025-08-13 07:57:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (353, 7, 'save_application_progress', NULL, '2025-08-13 07:57:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (354, 7, 'save_application_progress', NULL, '2025-08-13 07:57:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (355, 7, 'save_application_progress', NULL, '2025-08-13 07:59:05', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (356, 7, 'save_application_progress', NULL, '2025-08-13 07:59:09', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (357, 7, 'save_application_progress', NULL, '2025-08-13 08:00:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (358, 7, 'save_application_progress', NULL, '2025-08-13 08:00:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (359, 7, 'save_application_progress', NULL, '2025-08-13 08:00:48', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (360, 7, 'save_application_progress', NULL, '2025-08-13 08:01:18', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (361, 7, 'save_application_progress', NULL, '2025-08-13 08:01:46', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (362, 7, 'save_application_progress', NULL, '2025-08-13 08:01:48', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (363, 7, 'save_application_progress', NULL, '2025-08-13 08:02:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (364, 7, 'save_application_progress', NULL, '2025-08-13 08:03:11', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (365, 7, 'save_application_progress', NULL, '2025-08-13 08:04:05', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (366, 7, 'save_application_progress', NULL, '2025-08-13 08:04:19', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (367, 7, 'save_application_progress', NULL, '2025-08-13 08:04:49', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (368, 7, 'save_application_progress', NULL, '2025-08-13 08:05:19', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (369, 7, 'save_application_progress', NULL, '2025-08-13 08:05:49', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (370, 7, 'save_application_progress', NULL, '2025-08-13 08:06:19', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (371, 7, 'save_application_progress', NULL, '2025-08-13 08:06:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (372, 7, 'save_application_progress', NULL, '2025-08-13 08:07:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (373, 7, 'save_application_progress', NULL, '2025-08-13 08:08:00', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (374, 7, 'save_application_progress', NULL, '2025-08-13 08:08:30', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (375, 7, 'save_application_progress', NULL, '2025-08-13 08:08:34', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (376, 7, 'save_application_progress', NULL, '2025-08-13 08:08:47', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (377, 7, 'save_application_progress', NULL, '2025-08-13 08:08:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (378, 7, 'save_application_progress', NULL, '2025-08-13 08:09:11', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (379, 7, 'save_application_progress', NULL, '2025-08-13 08:09:27', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (380, 7, 'save_application_progress', NULL, '2025-08-13 08:09:32', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (381, 7, 'save_application_progress', NULL, '2025-08-13 08:09:43', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (382, 7, 'save_application_progress', NULL, '2025-08-13 08:09:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (383, 7, 'save_application_progress', NULL, '2025-08-13 08:10:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (384, 7, 'save_application_progress', NULL, '2025-08-13 08:11:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (385, 7, 'save_application_progress', NULL, '2025-08-13 08:12:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (386, 7, 'save_application_progress', NULL, '2025-08-13 08:13:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (387, 7, 'save_application_progress', NULL, '2025-08-13 08:14:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (388, 7, 'save_application_progress', NULL, '2025-08-13 08:15:18', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (389, 7, 'save_application_progress', NULL, '2025-08-13 08:15:40', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (390, 7, 'save_application_progress', NULL, '2025-08-13 08:15:42', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (391, 7, 'save_application_progress', NULL, '2025-08-13 08:15:55', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (392, 7, 'save_application_progress', NULL, '2025-08-13 08:15:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (393, 7, 'save_application_progress', NULL, '2025-08-13 08:16:17', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (394, 7, 'save_application_progress', NULL, '2025-08-13 08:17:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (395, 7, 'save_application_progress', NULL, '2025-08-13 08:18:09', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (396, 7, 'save_application_progress', NULL, '2025-08-13 08:20:12', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (397, 7, 'save_application_progress', NULL, '2025-08-13 08:21:17', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (398, 7, 'save_application_progress', NULL, '2025-08-13 08:24:58', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (399, 7, 'save_application_progress', NULL, '2025-08-13 08:25:30', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (400, 7, 'save_application_progress', NULL, '2025-08-13 08:25:33', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (401, 7, 'save_application_progress', NULL, '2025-08-13 08:25:45', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (402, 7, 'save_application_progress', NULL, '2025-08-13 08:26:05', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (403, 7, 'save_application_progress', NULL, '2025-08-13 08:41:05', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (404, 7, 'save_application_progress', NULL, '2025-08-13 08:41:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (405, 4, 'update_questions', '{\"description\": \"Updated qualification question text and options, deactivated redundant question\", \"question_ids\": [23, 24]}', '2025-08-13 09:55:28', NULL);
INSERT INTO `audit_logs` VALUES (406, 7, 'save_application_progress', NULL, '2025-08-13 09:56:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (407, 7, 'save_application_progress', NULL, '2025-08-13 09:56:49', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (408, 7, 'save_application_progress', NULL, '2025-08-13 09:57:05', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (409, 7, 'save_application_progress', NULL, '2025-08-13 09:57:51', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (410, 7, 'save_application_progress', NULL, '2025-08-13 09:58:21', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (411, 7, 'save_application_progress', NULL, '2025-08-13 09:58:31', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (412, 7, 'save_application_progress', NULL, '2025-08-13 09:59:01', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (413, 7, 'save_application_progress', NULL, '2025-08-13 09:59:05', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (414, 7, 'save_application_progress', NULL, '2025-08-13 09:59:18', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (415, 7, 'save_application_progress', NULL, '2025-08-13 09:59:25', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (416, 7, 'save_application_progress', NULL, '2025-08-13 09:59:33', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (417, 7, 'save_application_progress', NULL, '2025-08-13 09:59:39', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (418, 7, 'save_application_progress', NULL, '2025-08-13 09:59:54', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (419, 7, 'save_application_progress', NULL, '2025-08-13 10:00:34', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (420, 7, 'save_application_progress', NULL, '2025-08-13 10:00:43', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (421, 7, 'save_application_progress', NULL, '2025-08-13 10:01:21', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (422, 7, 'save_application_progress', NULL, '2025-08-13 10:01:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (423, 7, 'save_application_progress', NULL, '2025-08-13 10:02:03', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (424, 7, 'save_application_progress', NULL, '2025-08-13 10:02:39', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (425, 7, 'save_application_progress', NULL, '2025-08-13 10:03:09', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (426, 7, 'save_application_progress', NULL, '2025-08-13 10:03:39', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (427, 7, 'save_application_progress', NULL, '2025-08-13 10:03:40', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (428, 7, 'save_application_progress', NULL, '2025-08-13 10:04:00', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (429, 7, 'save_application_progress', NULL, '2025-08-13 10:04:39', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (430, 7, 'save_application_progress', NULL, '2025-08-13 10:05:09', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (431, 7, 'save_application_progress', NULL, '2025-08-13 10:05:27', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (432, 8, 'save_application_progress', NULL, '2025-08-13 13:49:31', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (433, 8, 'save_application_progress', NULL, '2025-08-13 13:49:35', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (434, 8, 'save_application_progress', NULL, '2025-08-13 13:49:51', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (435, 8, 'save_application_progress', NULL, '2025-08-13 13:50:14', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (436, 8, 'save_application_progress', NULL, '2025-08-13 13:51:33', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (437, 8, 'save_application_progress', NULL, '2025-08-13 13:52:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (438, 8, 'save_application_progress', NULL, '2025-08-13 13:52:24', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (439, 8, 'save_application_progress', NULL, '2025-08-13 13:57:04', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (440, 8, 'save_application_progress', NULL, '2025-08-13 13:57:14', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (441, 8, 'save_application_progress', NULL, '2025-08-13 13:57:22', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (442, 8, 'save_application_progress', NULL, '2025-08-13 13:57:29', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (443, 8, 'save_application_progress', NULL, '2025-08-13 13:57:35', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (444, 8, 'save_application_progress', NULL, '2025-08-13 13:57:42', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (445, 8, 'save_application_progress', NULL, '2025-08-13 13:57:50', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (446, 8, 'save_application_progress', NULL, '2025-08-13 13:57:54', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (447, 8, 'save_application_progress', NULL, '2025-08-13 13:58:35', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (448, 8, 'save_application_progress', NULL, '2025-08-13 13:59:05', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (449, 8, 'save_application_progress', NULL, '2025-08-13 13:59:07', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (450, 8, 'save_application_progress', NULL, '2025-08-13 13:59:25', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (451, 8, 'save_application_progress', NULL, '2025-08-13 14:00:04', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (452, 8, 'save_application_progress', NULL, '2025-08-13 14:00:34', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (453, 8, 'save_application_progress', NULL, '2025-08-13 14:01:04', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (454, 8, 'save_application_progress', NULL, '2025-08-13 14:01:34', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (455, 8, 'save_application_progress', NULL, '2025-08-13 14:02:04', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (456, 8, 'save_application_progress', NULL, '2025-08-13 14:02:34', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (457, 8, 'save_application_progress', NULL, '2025-08-13 14:03:51', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (458, 8, 'save_application_progress', NULL, '2025-08-13 14:04:51', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (459, 8, 'save_application_progress', NULL, '2025-08-13 14:05:04', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (460, 8, 'save_application_progress', NULL, '2025-08-13 14:05:23', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (461, 8, 'save_application_progress', NULL, '2025-08-13 14:05:29', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (462, 8, 'save_application_progress', NULL, '2025-08-13 14:05:47', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (463, 8, 'save_application_progress', NULL, '2025-08-13 14:06:21', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (464, 8, 'save_application_progress', NULL, '2025-08-13 14:08:00', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (465, 8, 'save_application_progress', NULL, '2025-08-13 14:08:16', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (466, 8, 'save_application_progress', NULL, '2025-08-13 14:08:59', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (467, 8, 'save_application_progress', NULL, '2025-08-13 14:09:08', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (468, 8, 'save_application_progress', NULL, '2025-08-13 14:09:18', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (469, 8, 'save_application_progress', NULL, '2025-08-13 14:11:28', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (470, 8, 'save_application_progress', NULL, '2025-08-13 14:38:24', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (471, 8, 'save_application_progress', NULL, '2025-08-13 14:38:54', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (472, 8, 'save_application_progress', NULL, '2025-08-13 14:39:24', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (473, 8, 'save_application_progress', NULL, '2025-08-13 14:39:54', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (474, 8, 'save_application_progress', NULL, '2025-08-13 14:40:23', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (475, 8, 'save_application_progress', NULL, '2025-08-13 14:40:36', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (476, 8, 'save_application_progress', NULL, '2025-08-13 14:40:47', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (477, 8, 'save_application_progress', NULL, '2025-08-13 14:41:05', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (478, 8, 'save_application_progress', NULL, '2025-08-13 14:41:31', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (479, 8, 'save_application_progress', NULL, '2025-08-13 14:42:39', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (480, 8, 'save_application_progress', NULL, '2025-08-13 14:42:54', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (481, 8, 'save_application_progress', NULL, '2025-08-13 15:02:32', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (482, 8, 'save_application_progress', NULL, '2025-08-13 15:03:01', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (483, 8, 'save_application_progress', NULL, '2025-08-13 15:03:23', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (484, 8, 'save_application_progress', NULL, '2025-08-13 15:03:51', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (485, 8, 'save_application_progress', NULL, '2025-08-13 15:04:29', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (486, 8, 'save_application_progress', NULL, '2025-08-13 15:04:38', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (487, 8, 'save_application_progress', NULL, '2025-08-13 15:04:46', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (488, 8, 'save_application_progress', NULL, '2025-08-13 15:19:31', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (489, 8, 'save_application_progress', NULL, '2025-08-13 15:19:38', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (490, 8, 'save_application_progress', NULL, '2025-08-13 15:19:54', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (491, 8, 'save_application_progress', NULL, '2025-08-13 15:20:13', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (492, 8, 'save_application_progress', NULL, '2025-08-13 15:20:33', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (493, 8, 'save_application_progress', NULL, '2025-08-13 15:21:12', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (494, 8, 'save_application_progress', NULL, '2025-08-13 15:21:42', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (495, 8, 'save_application_progress', NULL, '2025-08-13 15:22:12', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (496, 8, 'save_application_progress', NULL, '2025-08-13 15:22:42', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (497, 8, 'save_application_progress', NULL, '2025-08-13 15:23:12', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (498, 8, 'save_application_progress', NULL, '2025-08-13 15:23:42', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (499, 8, 'save_application_progress', NULL, '2025-08-13 15:24:40', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (500, 8, 'save_application_progress', NULL, '2025-08-13 15:24:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (501, 8, 'save_application_progress', NULL, '2025-08-13 15:25:41', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (502, 8, 'save_application_progress', NULL, '2025-08-13 15:26:12', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (503, 8, 'save_application_progress', NULL, '2025-08-13 15:26:42', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (504, 8, 'save_application_progress', NULL, '2025-08-13 15:27:32', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (505, 8, 'save_application_progress', NULL, '2025-08-13 15:27:42', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (506, 8, 'save_application_progress', NULL, '2025-08-13 15:27:48', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (507, 8, 'save_application_progress', NULL, '2025-08-13 15:57:43', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (508, 8, 'save_application_progress', NULL, '2025-08-13 15:58:02', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (509, 8, 'save_application_progress', NULL, '2025-08-13 15:58:07', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (510, 8, 'save_application_progress', NULL, '2025-08-13 15:58:26', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (511, 8, 'save_application_progress', NULL, '2025-08-13 15:58:54', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (512, 8, 'save_application_progress', NULL, '2025-08-13 15:59:21', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (513, 8, 'save_application_progress', NULL, '2025-08-13 16:01:12', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (514, 8, 'save_application_progress', NULL, '2025-08-13 16:03:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (515, 8, 'save_application_progress', NULL, '2025-08-13 16:04:04', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (516, 8, 'save_application_progress', NULL, '2025-08-13 16:04:15', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (517, 8, 'save_application_progress', NULL, '2025-08-13 16:04:38', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (518, 8, 'save_application_progress', NULL, '2025-08-13 16:05:13', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (519, 8, 'save_application_progress', NULL, '2025-08-13 16:05:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (520, 8, 'save_application_progress', NULL, '2025-08-13 16:07:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (521, 8, 'save_application_progress', NULL, '2025-08-13 16:07:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (522, 8, 'save_application_progress', NULL, '2025-08-13 16:08:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (523, 8, 'save_application_progress', NULL, '2025-08-13 16:08:50', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (524, 8, 'save_application_progress', NULL, '2025-08-13 16:09:23', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (525, 8, 'save_application_progress', NULL, '2025-08-13 16:09:50', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (526, 8, 'save_application_progress', NULL, '2025-08-13 16:10:23', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (527, 8, 'save_application_progress', NULL, '2025-08-13 16:11:18', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (528, 8, 'save_application_progress', NULL, '2025-08-13 16:11:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (529, 8, 'save_application_progress', NULL, '2025-08-13 16:11:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (530, 8, 'save_application_progress', NULL, '2025-08-13 16:12:54', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (531, 8, 'save_application_progress', NULL, '2025-08-13 16:14:26', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (532, 8, 'save_application_progress', NULL, '2025-08-13 16:18:09', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (533, 8, 'save_application_progress', NULL, '2025-08-13 16:18:21', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (534, 8, 'save_application_progress', NULL, '2025-08-13 16:18:43', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (535, 8, 'save_application_progress', NULL, '2025-08-13 16:19:23', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (536, 8, 'save_application_progress', NULL, '2025-08-13 16:19:36', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (537, 8, 'save_application_progress', NULL, '2025-08-13 16:19:44', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (538, 8, 'save_application_progress', NULL, '2025-08-13 16:19:52', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (539, 8, 'save_application_progress', NULL, '2025-08-13 16:20:18', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (540, 8, 'save_application_progress', NULL, '2025-08-13 16:20:28', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (541, 8, 'save_application_progress', NULL, '2025-08-13 16:21:05', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (542, 8, 'save_application_progress', NULL, '2025-08-13 16:21:34', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (543, 8, 'save_application_progress', NULL, '2025-08-13 16:22:04', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (544, 8, 'save_application_progress', NULL, '2025-08-13 16:22:34', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (545, 8, 'save_application_progress', NULL, '2025-08-13 16:22:53', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (546, 8, 'save_application_progress', NULL, '2025-08-13 16:23:28', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (547, 8, 'save_application_progress', NULL, '2025-08-13 16:23:57', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (548, 8, 'save_application_progress', NULL, '2025-08-13 16:24:27', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (549, 8, 'save_application_progress', NULL, '2025-08-13 16:24:58', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (550, 8, 'save_application_progress', NULL, '2025-08-13 16:25:27', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (551, 8, 'save_application_progress', NULL, '2025-08-13 16:25:57', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (552, 8, 'save_application_progress', NULL, '2025-08-13 16:26:33', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (553, 8, 'save_application_progress', NULL, '2025-08-13 16:27:34', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (554, 8, 'save_application_progress', NULL, '2025-08-13 16:28:34', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (555, 8, 'save_application_progress', NULL, '2025-08-13 16:29:35', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (556, 8, 'save_application_progress', NULL, '2025-08-13 16:30:36', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (557, 8, 'save_application_progress', NULL, '2025-08-13 16:31:38', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (558, 8, 'save_application_progress', NULL, '2025-08-13 16:32:40', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (559, 8, 'save_application_progress', NULL, '2025-08-13 16:33:39', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (560, 8, 'save_application_progress', NULL, '2025-08-13 16:33:59', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (561, 8, 'save_application_progress', NULL, '2025-08-13 16:42:29', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (562, 8, 'save_application_progress', NULL, '2025-08-13 16:42:37', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (563, 8, 'save_application_progress', NULL, '2025-08-13 16:42:51', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (564, 8, 'save_application_progress', NULL, '2025-08-13 16:43:08', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (565, 8, 'save_application_progress', NULL, '2025-08-13 16:43:34', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (566, 8, 'save_application_progress', NULL, '2025-08-13 16:43:38', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (567, 8, 'save_application_progress', NULL, '2025-08-13 16:43:45', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (568, 8, 'save_application_progress', NULL, '2025-08-13 16:43:51', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (569, 8, 'save_application_progress', NULL, '2025-08-13 16:43:56', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (570, 8, 'save_application_progress', NULL, '2025-08-13 16:43:59', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (571, 8, 'save_application_progress', NULL, '2025-08-13 16:44:05', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (572, 8, 'save_application_progress', NULL, '2025-08-13 16:44:10', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (573, 8, 'save_application_progress', NULL, '2025-08-13 16:44:26', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (574, 8, 'save_application_progress', NULL, '2025-08-13 16:45:17', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (575, 8, 'save_application_progress', NULL, '2025-08-13 16:45:52', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (576, 8, 'save_application_progress', NULL, '2025-08-13 16:46:50', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (577, 8, 'save_application_progress', NULL, '2025-08-13 16:47:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (578, 8, 'save_application_progress', NULL, '2025-08-13 16:47:50', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (579, 8, 'save_application_progress', NULL, '2025-08-13 16:48:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (580, 8, 'save_application_progress', NULL, '2025-08-13 16:48:50', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (581, 8, 'save_application_progress', NULL, '2025-08-13 16:49:20', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (582, 8, 'save_application_progress', NULL, '2025-08-13 16:49:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (583, 8, 'save_application_progress', NULL, '2025-08-13 16:50:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (584, 8, 'save_application_progress', NULL, '2025-08-13 16:51:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (585, 8, 'save_application_progress', NULL, '2025-08-13 16:52:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (586, 8, 'save_application_progress', NULL, '2025-08-13 16:53:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (587, 8, 'save_application_progress', NULL, '2025-08-13 16:54:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (588, 8, 'save_application_progress', NULL, '2025-08-13 16:55:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (589, 8, 'save_application_progress', NULL, '2025-08-13 16:56:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (590, 8, 'save_application_progress', NULL, '2025-08-13 16:57:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (591, 8, 'save_application_progress', NULL, '2025-08-13 16:58:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (592, 8, 'save_application_progress', NULL, '2025-08-13 16:59:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (593, 8, 'save_application_progress', NULL, '2025-08-13 17:00:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (594, 8, 'save_application_progress', NULL, '2025-08-13 17:01:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (595, 8, 'save_application_progress', NULL, '2025-08-13 17:02:51', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (596, 8, 'save_application_progress', NULL, '2025-08-13 17:11:42', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (597, 8, 'save_application_progress', NULL, '2025-08-13 17:11:46', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (598, 8, 'save_application_progress', NULL, '2025-08-13 17:12:07', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (599, 8, 'save_application_progress', NULL, '2025-08-13 17:12:49', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (600, 8, 'save_application_progress', NULL, '2025-08-13 17:13:17', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (601, 8, 'save_application_progress', NULL, '2025-08-13 17:13:21', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (602, 8, 'save_application_progress', NULL, '2025-08-13 17:13:29', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (603, 8, 'save_application_progress', NULL, '2025-08-13 17:13:30', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (604, 8, 'save_application_progress', NULL, '2025-08-13 17:13:35', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (605, 8, 'save_application_progress', NULL, '2025-08-13 17:13:40', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (606, 8, 'save_application_progress', NULL, '2025-08-13 17:13:44', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (607, 8, 'save_application_progress', NULL, '2025-08-13 17:13:49', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (608, 8, 'save_application_progress', NULL, '2025-08-13 17:13:51', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (609, 8, 'save_application_progress', NULL, '2025-08-13 17:14:05', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (610, 8, 'save_application_progress', NULL, '2025-08-13 17:14:27', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (611, 8, 'save_application_progress', NULL, '2025-08-13 17:14:34', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (612, 8, 'save_application_progress', NULL, '2025-08-13 17:17:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (613, 8, 'save_application_progress', NULL, '2025-08-13 17:18:24', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (614, 8, 'save_application_progress', NULL, '2025-08-13 17:18:54', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (615, 8, 'save_application_progress', NULL, '2025-08-13 17:19:24', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (616, 8, 'save_application_progress', NULL, '2025-08-13 17:19:55', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (617, 8, 'save_application_progress', NULL, '2025-08-13 17:20:25', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (618, 8, 'save_application_progress', NULL, '2025-08-13 17:20:55', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (619, 8, 'save_application_progress', NULL, '2025-08-13 17:21:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (620, 8, 'save_application_progress', NULL, '2025-08-13 17:22:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (621, 8, 'save_application_progress', NULL, '2025-08-13 17:23:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (622, 8, 'save_application_progress', NULL, '2025-08-13 17:24:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (623, 8, 'save_application_progress', NULL, '2025-08-13 17:25:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (624, 8, 'save_application_progress', NULL, '2025-08-13 17:26:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (625, 8, 'save_application_progress', NULL, '2025-08-13 17:27:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (626, 8, 'save_application_progress', NULL, '2025-08-13 17:28:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (627, 8, 'save_application_progress', NULL, '2025-08-13 17:29:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (628, 8, 'save_application_progress', NULL, '2025-08-13 17:30:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (629, 8, 'save_application_progress', NULL, '2025-08-13 17:31:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (630, 8, 'save_application_progress', NULL, '2025-08-13 17:32:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (631, 8, 'save_application_progress', NULL, '2025-08-13 21:22:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (632, 8, 'save_application_progress', NULL, '2025-08-13 21:22:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (633, 8, 'save_application_progress', NULL, '2025-08-13 21:23:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (634, 8, 'save_application_progress', NULL, '2025-08-13 21:23:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (635, 8, 'save_application_progress', NULL, '2025-08-13 21:24:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (636, 8, 'save_application_progress', NULL, '2025-08-13 21:24:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (637, 8, 'save_application_progress', NULL, '2025-08-13 21:25:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (638, 8, 'save_application_progress', NULL, '2025-08-13 21:25:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (639, 8, 'save_application_progress', NULL, '2025-08-13 21:26:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (640, 8, 'save_application_progress', NULL, '2025-08-13 21:26:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (641, 8, 'save_application_progress', NULL, '2025-08-13 21:27:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (642, 8, 'save_application_progress', NULL, '2025-08-13 21:27:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (643, 8, 'save_application_progress', NULL, '2025-08-13 21:28:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (644, 8, 'save_application_progress', NULL, '2025-08-13 21:28:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (645, 8, 'save_application_progress', NULL, '2025-08-13 21:29:15', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (646, 8, 'save_application_progress', NULL, '2025-08-13 21:29:29', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (647, 8, 'save_application_progress', NULL, '2025-08-13 21:29:32', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (648, 8, 'save_application_progress', NULL, '2025-08-13 21:29:47', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (649, 8, 'save_application_progress', NULL, '2025-08-13 21:30:50', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (650, 8, 'save_application_progress', NULL, '2025-08-13 21:32:07', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (651, 8, 'save_application_progress', NULL, '2025-08-13 21:32:15', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (652, 8, 'save_application_progress', NULL, '2025-08-13 21:32:25', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (653, 8, 'save_application_progress', NULL, '2025-08-13 21:32:30', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (654, 8, 'save_application_progress', NULL, '2025-08-13 21:32:35', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (655, 8, 'save_application_progress', NULL, '2025-08-13 21:32:41', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (656, 8, 'save_application_progress', NULL, '2025-08-13 21:32:47', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (657, 8, 'save_application_progress', NULL, '2025-08-13 21:32:53', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (658, 8, 'save_application_progress', NULL, '2025-08-13 21:33:03', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (659, 8, 'save_application_progress', NULL, '2025-08-13 21:35:25', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (660, 8, 'save_application_progress', NULL, '2025-08-13 21:36:07', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (661, 8, 'save_application_progress', NULL, '2025-08-13 21:36:37', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (662, 8, 'save_application_progress', NULL, '2025-08-13 21:37:07', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (663, 8, 'save_application_progress', NULL, '2025-08-13 21:37:37', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (664, 8, 'save_application_progress', NULL, '2025-08-13 21:38:08', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (665, 8, 'save_application_progress', NULL, '2025-08-13 21:38:38', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (666, 8, 'save_application_progress', NULL, '2025-08-13 21:39:46', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (667, 8, 'save_application_progress', NULL, '2025-08-13 21:40:46', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (668, 8, 'save_application_progress', NULL, '2025-08-13 21:41:47', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (669, 8, 'save_application_progress', NULL, '2025-08-13 21:42:48', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (670, 8, 'save_application_progress', NULL, '2025-08-13 21:43:49', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (671, 8, 'save_application_progress', NULL, '2025-08-13 21:44:50', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (672, 8, 'save_application_progress', NULL, '2025-08-13 21:45:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (673, 8, 'save_application_progress', NULL, '2025-08-13 21:46:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (674, 8, 'save_application_progress', NULL, '2025-08-13 21:47:23', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (675, 8, 'save_application_progress', NULL, '2025-08-13 21:47:38', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (676, 8, 'save_application_progress', NULL, '2025-08-13 21:48:08', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (677, 8, 'save_application_progress', NULL, '2025-08-13 21:48:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (678, 8, 'save_application_progress', NULL, '2025-08-13 21:49:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (679, 8, 'save_application_progress', NULL, '2025-08-13 21:50:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (680, 8, 'save_application_progress', NULL, '2025-08-13 21:51:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (681, 8, 'save_application_progress', NULL, '2025-08-13 21:52:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (682, 8, 'save_application_progress', NULL, '2025-08-13 21:53:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (683, 8, 'save_application_progress', NULL, '2025-08-13 21:54:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (684, 8, 'save_application_progress', NULL, '2025-08-13 21:55:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (685, 8, 'save_application_progress', NULL, '2025-08-13 21:56:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (686, 8, 'save_application_progress', NULL, '2025-08-13 21:57:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (687, 8, 'save_application_progress', NULL, '2025-08-13 21:58:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (688, 8, 'save_application_progress', NULL, '2025-08-13 21:59:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (689, 8, 'save_application_progress', NULL, '2025-08-13 22:00:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (690, 8, 'save_application_progress', NULL, '2025-08-13 22:01:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (691, 8, 'save_application_progress', NULL, '2025-08-13 22:02:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (692, 8, 'save_application_progress', NULL, '2025-08-13 22:03:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (693, 8, 'save_application_progress', NULL, '2025-08-13 22:04:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (694, 8, 'save_application_progress', NULL, '2025-08-13 22:05:37', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (695, 8, 'save_application_progress', NULL, '2025-08-13 22:06:08', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (696, 8, 'save_application_progress', NULL, '2025-08-13 22:06:38', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (697, 8, 'save_application_progress', NULL, '2025-08-13 22:07:08', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (698, 8, 'save_application_progress', NULL, '2025-08-13 22:07:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (699, 8, 'save_application_progress', NULL, '2025-08-13 22:08:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (700, 8, 'save_application_progress', NULL, '2025-08-13 22:09:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (701, 8, 'save_application_progress', NULL, '2025-08-13 22:10:51', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (702, 8, 'save_application_progress', NULL, '2025-08-13 22:11:24', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (703, 8, 'save_application_progress', NULL, '2025-08-13 22:11:58', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (704, 8, 'save_application_progress', NULL, '2025-08-13 22:12:28', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (705, 8, 'save_application_progress', NULL, '2025-08-13 22:12:58', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (706, 8, 'save_application_progress', NULL, '2025-08-13 22:13:28', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (707, 8, 'save_application_progress', NULL, '2025-08-13 22:13:58', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (708, 8, 'save_application_progress', NULL, '2025-08-13 22:14:28', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (709, 8, 'save_application_progress', NULL, '2025-08-13 22:14:58', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (710, 8, 'save_application_progress', NULL, '2025-08-13 22:16:11', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (711, 8, 'save_application_progress', NULL, '2025-08-13 22:16:40', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (712, 8, 'save_application_progress', NULL, '2025-08-13 22:17:10', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (713, 8, 'save_application_progress', NULL, '2025-08-13 22:17:40', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (714, 8, 'save_application_progress', NULL, '2025-08-13 22:18:10', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (715, 8, 'save_application_progress', NULL, '2025-08-13 22:18:40', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (716, 8, 'save_application_progress', NULL, '2025-08-13 22:19:11', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (717, 8, 'save_application_progress', NULL, '2025-08-13 22:20:17', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (718, 8, 'save_application_progress', NULL, '2025-08-13 22:20:47', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (719, 8, 'save_application_progress', NULL, '2025-08-13 22:21:17', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (720, 8, 'save_application_progress', NULL, '2025-08-13 22:23:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (721, 8, 'save_application_progress', NULL, '2025-08-13 22:23:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (722, 8, 'save_application_progress', NULL, '2025-08-13 22:24:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (723, 8, 'save_application_progress', NULL, '2025-08-13 22:24:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (724, 8, 'save_application_progress', NULL, '2025-08-13 22:25:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (725, 8, 'save_application_progress', NULL, '2025-08-13 22:25:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (726, 8, 'save_application_progress', NULL, '2025-08-13 22:26:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (727, 8, 'save_application_progress', NULL, '2025-08-13 22:27:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (728, 8, 'save_application_progress', NULL, '2025-08-13 22:28:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (729, 8, 'save_application_progress', NULL, '2025-08-13 22:29:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (730, 8, 'save_application_progress', NULL, '2025-08-13 22:30:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (731, 8, 'save_application_progress', NULL, '2025-08-13 22:31:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (732, 8, 'save_application_progress', NULL, '2025-08-13 22:32:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (733, 8, 'save_application_progress', NULL, '2025-08-13 22:33:26', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (734, 8, 'save_application_progress', NULL, '2025-08-13 22:33:49', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (735, 8, 'save_application_progress', NULL, '2025-08-13 22:34:19', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (736, 8, 'save_application_progress', NULL, '2025-08-13 22:34:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (737, 8, 'save_application_progress', NULL, '2025-08-13 22:35:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (738, 8, 'save_application_progress', NULL, '2025-08-13 22:35:49', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (739, 8, 'save_application_progress', NULL, '2025-08-13 22:36:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (740, 8, 'save_application_progress', NULL, '2025-08-13 22:36:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (741, 8, 'save_application_progress', NULL, '2025-08-13 22:37:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (742, 8, 'save_application_progress', NULL, '2025-08-13 22:38:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (743, 8, 'save_application_progress', NULL, '2025-08-13 22:39:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (744, 8, 'save_application_progress', NULL, '2025-08-13 22:40:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (745, 8, 'save_application_progress', NULL, '2025-08-13 22:41:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (746, 8, 'save_application_progress', NULL, '2025-08-13 22:42:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (747, 8, 'save_application_progress', NULL, '2025-08-13 22:43:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (748, 8, 'save_application_progress', NULL, '2025-08-13 22:44:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (749, 8, 'save_application_progress', NULL, '2025-08-13 22:45:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (750, 8, 'save_application_progress', NULL, '2025-08-13 22:46:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (751, 8, 'save_application_progress', NULL, '2025-08-13 22:47:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (752, 8, 'save_application_progress', NULL, '2025-08-13 22:48:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (753, 8, 'save_application_progress', NULL, '2025-08-13 22:49:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (754, 8, 'save_application_progress', NULL, '2025-08-13 22:50:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (755, 8, 'save_application_progress', NULL, '2025-08-13 22:51:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (756, 8, 'save_application_progress', NULL, '2025-08-13 22:51:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (757, 8, 'save_application_progress', NULL, '2025-08-13 22:52:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (758, 8, 'save_application_progress', NULL, '2025-08-13 22:53:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (759, 8, 'save_application_progress', NULL, '2025-08-13 22:54:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (760, 8, 'save_application_progress', NULL, '2025-08-13 22:55:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (761, 8, 'save_application_progress', NULL, '2025-08-13 22:56:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (762, 8, 'save_application_progress', NULL, '2025-08-13 22:57:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (763, 8, 'save_application_progress', NULL, '2025-08-13 22:58:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (764, 8, 'save_application_progress', NULL, '2025-08-13 22:59:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (765, 8, 'save_application_progress', NULL, '2025-08-13 23:00:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (766, 8, 'save_application_progress', NULL, '2025-08-13 23:01:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (767, 8, 'save_application_progress', NULL, '2025-08-13 23:02:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (768, 8, 'save_application_progress', NULL, '2025-08-13 23:03:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (769, 8, 'save_application_progress', NULL, '2025-08-13 23:04:26', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (770, 8, 'save_application_progress', NULL, '2025-08-13 23:04:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (771, 8, 'save_application_progress', NULL, '2025-08-13 23:05:19', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (772, 8, 'save_application_progress', NULL, '2025-08-13 23:05:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (773, 8, 'save_application_progress', NULL, '2025-08-13 23:06:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (774, 8, 'save_application_progress', NULL, '2025-08-13 23:06:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (775, 8, 'save_application_progress', NULL, '2025-08-13 23:07:20', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (776, 8, 'save_application_progress', NULL, '2025-08-13 23:07:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (777, 8, 'save_application_progress', NULL, '2025-08-13 23:08:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (778, 8, 'save_application_progress', NULL, '2025-08-13 23:09:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (779, 8, 'save_application_progress', NULL, '2025-08-13 23:10:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (780, 8, 'save_application_progress', NULL, '2025-08-13 23:11:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (781, 8, 'save_application_progress', NULL, '2025-08-13 23:12:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (782, 8, 'save_application_progress', NULL, '2025-08-13 23:13:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (783, 8, 'save_application_progress', NULL, '2025-08-13 23:14:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (784, 8, 'save_application_progress', NULL, '2025-08-13 23:15:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (785, 8, 'save_application_progress', NULL, '2025-08-13 23:16:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (786, 8, 'save_application_progress', NULL, '2025-08-13 23:52:12', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (787, 8, 'save_application_progress', NULL, '2025-08-13 23:52:42', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (788, 8, 'save_application_progress', NULL, '2025-08-13 23:53:12', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (789, 8, 'save_application_progress', NULL, '2025-08-13 23:53:42', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (790, 8, 'save_application_progress', NULL, '2025-08-13 23:54:12', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (791, 8, 'save_application_progress', NULL, '2025-08-13 23:54:42', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (792, 8, 'save_application_progress', NULL, '2025-08-13 23:55:43', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (793, 8, 'save_application_progress', NULL, '2025-08-13 23:56:44', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (794, 8, 'save_application_progress', NULL, '2025-08-13 23:57:45', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (795, 8, 'save_application_progress', NULL, '2025-08-13 23:58:46', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (796, 8, 'save_application_progress', NULL, '2025-08-13 23:59:47', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (797, 8, 'save_application_progress', NULL, '2025-08-14 00:00:48', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (798, 8, 'save_application_progress', NULL, '2025-08-14 00:01:49', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (799, 8, 'save_application_progress', NULL, '2025-08-14 00:02:50', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (800, 8, 'save_application_progress', NULL, '2025-08-14 00:03:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (801, 8, 'save_application_progress', NULL, '2025-08-14 00:04:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (802, 8, 'save_application_progress', NULL, '2025-08-14 00:05:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (803, 8, 'save_application_progress', NULL, '2025-08-14 00:06:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (804, 8, 'save_application_progress', NULL, '2025-08-14 00:07:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (805, 8, 'save_application_progress', NULL, '2025-08-14 00:08:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (806, 8, 'save_application_progress', NULL, '2025-08-14 00:09:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (807, 8, 'save_application_progress', NULL, '2025-08-14 00:10:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (808, 8, 'save_application_progress', NULL, '2025-08-14 00:11:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (809, 8, 'save_application_progress', NULL, '2025-08-14 00:12:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (810, 8, 'save_application_progress', NULL, '2025-08-14 00:13:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (811, 8, 'save_application_progress', NULL, '2025-08-14 00:14:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (812, 8, 'save_application_progress', NULL, '2025-08-14 00:15:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (813, 8, 'save_application_progress', NULL, '2025-08-14 00:16:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (814, 8, 'save_application_progress', NULL, '2025-08-14 00:17:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (815, 8, 'save_application_progress', NULL, '2025-08-14 00:18:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (816, 8, 'save_application_progress', NULL, '2025-08-14 00:19:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (817, 8, 'save_application_progress', NULL, '2025-08-14 00:20:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (818, 8, 'save_application_progress', NULL, '2025-08-14 00:21:32', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (819, 8, 'save_application_progress', NULL, '2025-08-14 00:21:59', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (820, 8, 'save_application_progress', NULL, '2025-08-14 00:22:05', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (821, 8, 'save_application_progress', NULL, '2025-08-14 00:22:20', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (822, 8, 'save_application_progress', NULL, '2025-08-14 00:22:45', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (823, 8, 'save_application_progress', NULL, '2025-08-14 00:23:38', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (824, 8, 'save_application_progress', NULL, '2025-08-14 00:24:05', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (825, 8, 'save_application_progress', NULL, '2025-08-14 00:24:13', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (826, 8, 'save_application_progress', NULL, '2025-08-14 00:30:41', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (827, 8, 'save_application_progress', NULL, '2025-08-14 00:30:44', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (828, 8, 'save_application_progress', NULL, '2025-08-14 00:30:59', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (829, 8, 'save_application_progress', NULL, '2025-08-14 00:31:21', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (830, 8, 'save_application_progress', NULL, '2025-08-14 00:33:03', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (831, 8, 'save_application_progress', NULL, '2025-08-14 00:33:09', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (832, 8, 'save_application_progress', NULL, '2025-08-14 00:33:23', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (833, 8, 'save_application_progress', NULL, '2025-08-14 00:33:40', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (834, 8, 'save_application_progress', NULL, '2025-08-14 00:34:16', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (835, 8, 'save_application_progress', NULL, '2025-08-14 00:34:18', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (836, 8, 'save_application_progress', NULL, '2025-08-14 00:34:28', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (837, 8, 'save_application_progress', NULL, '2025-08-14 00:34:35', '{\"step\":\"5\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (838, 8, 'save_application_progress', NULL, '2025-08-14 00:34:46', '{\"step\":\"6\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (839, 8, 'save_application_progress', NULL, '2025-08-14 00:34:52', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (840, 8, 'save_application_progress', NULL, '2025-08-14 00:34:57', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (841, 8, 'save_application_progress', NULL, '2025-08-14 00:35:03', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (842, 8, 'save_application_progress', NULL, '2025-08-14 00:35:09', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (843, 8, 'save_application_progress', NULL, '2025-08-14 00:35:12', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (844, 8, 'save_application_progress', NULL, '2025-08-14 00:35:24', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (845, 8, 'save_application_progress', NULL, '2025-08-14 00:35:56', '{\"step\":\"9\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (846, 8, 'save_application_progress', NULL, '2025-08-14 00:36:41', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (847, 8, 'save_application_progress', NULL, '2025-08-14 00:37:09', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (848, 8, 'save_application_progress', NULL, '2025-08-14 00:37:32', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (849, 8, 'save_application_progress', NULL, '2025-08-14 00:37:35', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (850, 8, 'save_application_progress', NULL, '2025-08-14 00:37:50', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (851, 8, 'save_application_progress', NULL, '2025-08-14 00:38:06', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (852, 8, 'save_application_progress', NULL, '2025-08-14 00:38:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (853, 8, 'save_application_progress', NULL, '2025-08-14 00:38:53', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (854, 8, 'save_application_progress', NULL, '2025-08-14 00:39:11', '{\"step\":\"1\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (855, 8, 'save_application_progress', NULL, '2025-08-14 00:39:28', '{\"step\":\"2\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (856, 8, 'save_application_progress', NULL, '2025-08-14 00:50:55', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (857, 8, 'save_application_progress', NULL, '2025-08-14 00:52:28', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (858, 8, 'save_application_progress', NULL, '2025-08-14 00:53:23', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (859, 8, 'save_application_progress', NULL, '2025-08-14 00:54:33', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (860, 8, 'save_application_progress', NULL, '2025-08-14 00:54:38', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (861, 8, 'save_application_progress', NULL, '2025-08-14 00:54:45', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (862, 8, 'save_application_progress', NULL, '2025-08-14 00:54:49', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (863, 8, 'save_application_progress', NULL, '2025-08-14 00:56:08', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (864, 8, 'save_application_progress', NULL, '2025-08-14 00:56:39', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (865, 8, 'save_application_progress', NULL, '2025-08-14 00:57:08', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (866, 8, 'save_application_progress', NULL, '2025-08-14 00:57:38', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (867, 8, 'save_application_progress', NULL, '2025-08-14 00:58:08', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (868, 8, 'save_application_progress', NULL, '2025-08-14 00:58:38', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (869, 8, 'save_application_progress', NULL, '2025-08-14 00:59:43', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (870, 8, 'save_application_progress', NULL, '2025-08-14 01:00:44', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (871, 8, 'save_application_progress', NULL, '2025-08-14 01:01:45', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (872, 8, 'save_application_progress', NULL, '2025-08-14 01:02:46', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (873, 8, 'save_application_progress', NULL, '2025-08-14 01:03:47', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (874, 8, 'save_application_progress', NULL, '2025-08-14 01:04:48', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (875, 8, 'save_application_progress', NULL, '2025-08-14 01:05:25', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (876, 8, 'save_application_progress', NULL, '2025-08-14 01:05:56', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (877, 8, 'save_application_progress', NULL, '2025-08-14 01:07:27', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (878, 8, 'save_application_progress', NULL, '2025-08-14 01:08:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (879, 8, 'save_application_progress', NULL, '2025-08-14 01:08:33', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (880, 8, 'save_application_progress', NULL, '2025-08-14 01:09:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (881, 8, 'save_application_progress', NULL, '2025-08-14 01:09:32', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (882, 8, 'save_application_progress', NULL, '2025-08-14 01:10:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (883, 8, 'save_application_progress', NULL, '2025-08-14 01:10:33', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (884, 8, 'save_application_progress', NULL, '2025-08-14 01:11:01', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (885, 8, 'save_application_progress', NULL, '2025-08-14 01:11:58', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (886, 8, 'save_application_progress', NULL, '2025-08-14 01:12:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (887, 8, 'save_application_progress', NULL, '2025-08-14 01:13:33', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (888, 8, 'save_application_progress', NULL, '2025-08-14 01:14:03', '{\"step\":\"3\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (889, 8, 'save_application_progress', NULL, '2025-08-14 01:15:07', '{\"step\":\"4\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (890, 8, 'save_application_progress', NULL, '2025-08-14 01:15:38', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (891, 8, 'save_application_progress', NULL, '2025-08-14 01:15:42', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (892, 8, 'save_application_progress', NULL, '2025-08-14 01:15:47', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (893, 8, 'save_application_progress', NULL, '2025-08-14 01:15:52', '{\"step\":\"7\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (894, 8, 'save_application_progress', NULL, '2025-08-14 01:16:30', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (895, 8, 'save_application_progress', NULL, '2025-08-14 01:17:00', '{\"step\":\"8\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (896, 8, 'save_application_progress', NULL, '2025-08-14 01:18:45', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (897, 8, 'save_application_progress', NULL, '2025-08-14 01:19:16', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (898, 8, 'save_application_progress', NULL, '2025-08-14 01:19:46', '{\"step\":\"10\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (899, 8, 'save_application_progress', NULL, '2025-08-14 01:21:03', '{\"step\":\"11\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (900, 8, 'save_application_progress', NULL, '2025-08-14 01:21:33', '{\"step\":\"11\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (901, 8, 'save_application_progress', NULL, '2025-08-14 01:22:03', '{\"step\":\"11\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (902, 8, 'save_application_progress', NULL, '2025-08-14 01:22:33', '{\"step\":\"11\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (903, 8, 'save_application_progress', NULL, '2025-08-14 01:23:22', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (904, 8, 'save_application_progress', NULL, '2025-08-14 01:23:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (905, 8, 'save_application_progress', NULL, '2025-08-14 01:24:22', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (906, 8, 'save_application_progress', NULL, '2025-08-14 01:24:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (907, 8, 'save_application_progress', NULL, '2025-08-14 01:25:22', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (908, 8, 'save_application_progress', NULL, '2025-08-14 01:25:52', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (909, 8, 'save_application_progress', NULL, '2025-08-14 01:26:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (910, 8, 'save_application_progress', NULL, '2025-08-14 01:27:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (911, 8, 'save_application_progress', NULL, '2025-08-14 01:28:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (912, 8, 'save_application_progress', NULL, '2025-08-14 01:29:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (913, 8, 'save_application_progress', NULL, '2025-08-14 01:30:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (914, 8, 'save_application_progress', NULL, '2025-08-14 01:31:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (915, 8, 'save_application_progress', NULL, '2025-08-14 01:32:51', '{\"step\":\"0\",\"files_count\":0}');
INSERT INTO `audit_logs` VALUES (916, 8, 'save_application_progress', NULL, '2025-08-14 01:33:57', '{\"step\":\"0\",\"files_count\":0}');

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `display_order` int NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, 'Application Fee', 1, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (2, 'Personal Information', 2, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (3, 'Contact Information', 3, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (4, 'Academic History', 4, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (5, 'Program Details', 5, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (6, 'Supporting Documents', 6, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (7, 'Work Experience', 7, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (8, 'Financial Information', 8, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (9, 'Additional Information', 9, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');
INSERT INTO `categories` VALUES (10, 'Declarations & Agreements', 10, 1, '2025-07-19 01:44:16', '2025-07-19 01:44:16');

-- ----------------------------
-- Table structure for documents
-- ----------------------------
DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NULL DEFAULT NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `file_type` enum('certificate','photo','id','transcript') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `application_id`(`application_id` ASC) USING BTREE,
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of documents
-- ----------------------------

-- ----------------------------
-- Table structure for messages
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NULL DEFAULT NULL,
  `receiver_id` int NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sender_id`(`sender_id` ASC) USING BTREE,
  INDEX `receiver_id`(`receiver_id` ASC) USING BTREE,
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of messages
-- ----------------------------

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `type` enum('application_submitted','interview','offer_letter','payment_initiated') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications
-- ----------------------------

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicant_id` int NULL DEFAULT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `payment_method` enum('bank','online') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `transaction_reference` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_confirmation_pin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `depositor_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `depositor_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `payment_status` enum('pending','confirmed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `verified_by` int NULL DEFAULT NULL,
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `bank_user_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `applicant_id`(`applicant_id` ASC) USING BTREE,
  INDEX `verified_by`(`verified_by` ASC) USING BTREE,
  INDEX `bank_user_id`(`bank_user_id` ASC) USING BTREE,
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`applicant_id`) REFERENCES `applications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`bank_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payments
-- ----------------------------
INSERT INTO `payments` VALUES (5, NULL, 500.00, 'bank', 'TXN9200733701', '323233', 'Emmanuel Koroma', NULL, 'pending', NULL, '2025-08-07 00:28:20', 4);

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `feature_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `can_create` tinyint(1) NULL DEFAULT 0,
  `can_read` tinyint(1) NULL DEFAULT 0,
  `can_update` tinyint(1) NULL DEFAULT 0,
  `can_delete` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES (1, 4, 'application_management', 1, 1, 1, 1);
INSERT INTO `permissions` VALUES (2, 4, 'document_review', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (3, 4, 'interview_scheduling', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (4, 4, 'offer_letter_management', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (5, 4, 'payment_verification', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (6, 4, 'financial_reports', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (7, 4, 'user_management', 1, 1, 1, 1);
INSERT INTO `permissions` VALUES (8, 4, 'system_settings', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (9, 4, 'analytics_dashboard', 1, 1, 1, 1);
INSERT INTO `permissions` VALUES (10, 4, 'notification_management', 1, 1, 1, 0);
INSERT INTO `permissions` VALUES (11, 4, 'document_download', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (12, 4, 'bulk_operations', 1, 1, 0, 0);
INSERT INTO `permissions` VALUES (13, 4, 'analytics', 1, 1, 1, 1);
INSERT INTO `permissions` VALUES (14, 4, 'question_management', 1, 1, 1, 1);

-- ----------------------------
-- Table structure for question_table_columns
-- ----------------------------
DROP TABLE IF EXISTS `question_table_columns`;
CREATE TABLE `question_table_columns`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `column_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `column_type` enum('text','number','select','textarea') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'text',
  `is_required` tinyint(1) NULL DEFAULT 0,
  `sort_order` int NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('text','number','select','textarea','date','email','tel') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'text',
  `options` json NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `question_id`(`question_id` ASC) USING BTREE,
  CONSTRAINT `question_table_columns_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_table_columns
-- ----------------------------
INSERT INTO `question_table_columns` VALUES (1, 48, 'School Name', 'text', 1, 0, '2025-08-14 00:11:12', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (2, 48, 'Start Year', 'number', 1, 1, '2025-08-14 00:11:12', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (3, 48, 'End Year', 'number', 1, 2, '2025-08-14 00:11:12', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (4, 50, 'Employer Name and Address', 'text', 1, 0, '2025-08-14 00:15:59', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (5, 50, 'Job Title', 'text', 1, 1, '2025-08-14 00:15:59', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (6, 50, 'Start Month', 'select', 1, 2, '2025-08-14 00:15:59', 'text', '[\"January\", \"February\", \"March\", \"April\", \"May\", \"June\", \"July\", \"August\", \"September\", \"October\", \"November\", \"December\"]');
INSERT INTO `question_table_columns` VALUES (7, 50, 'Start Year', 'number', 1, 3, '2025-08-14 00:15:59', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (8, 50, 'End Month', 'select', 0, 4, '2025-08-14 00:15:59', 'text', '[\"January\", \"February\", \"March\", \"April\", \"May\", \"June\", \"July\", \"August\", \"September\", \"October\", \"November\", \"December\"]');
INSERT INTO `question_table_columns` VALUES (9, 50, 'End Year', 'number', 0, 5, '2025-08-14 00:15:59', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (10, 50, 'Responsibilities and Achievements', 'textarea', 1, 6, '2025-08-14 00:15:59', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (11, 52, 'Name', 'text', 1, 0, '2025-08-14 00:19:51', 'text', NULL);
INSERT INTO `question_table_columns` VALUES (12, 52, 'Phone Number', 'text', 1, 1, '2025-08-14 00:19:51', 'tel', NULL);
INSERT INTO `question_table_columns` VALUES (13, 52, 'Email', 'text', 0, 2, '2025-08-14 00:19:51', 'email', NULL);
INSERT INTO `question_table_columns` VALUES (14, 52, 'Relationship', 'text', 1, 3, '2025-08-14 00:19:51', 'text', NULL);

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NULL DEFAULT NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `section` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `question_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `question_type` enum('text','textarea','single_select','multiple_select','date','file','number','email','phone','table') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `options` json NULL,
  `validation_rules` json NULL,
  `conditional_logic` json NULL,
  `is_required` tinyint(1) NULL DEFAULT 0,
  `sort_order` int NULL DEFAULT 0,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `category_order` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `questions_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `questions_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of questions
-- ----------------------------
INSERT INTO `questions` VALUES (1, 1, 'Application Fee', 'payment', 'Payment Method', 'single_select', '[\"Bank Transfer\", \"Afri Money\", \"Mobile Money\"]', NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (2, 1, 'Application Fee', 'payment', 'Transaction PIN/Reference', 'text', NULL, NULL, NULL, 1, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (3, 1, 'Application Fee', 'payment', 'Upload Proof of Payment', 'file', NULL, NULL, NULL, 1, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (4, 2, 'Personal Information', 'basic_info', 'First Name', 'text', NULL, NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (5, 2, 'Personal Information', 'basic_info', 'Middle Name', 'text', NULL, NULL, NULL, 0, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (6, 2, 'Personal Information', 'basic_info', 'Last Name', 'text', NULL, NULL, NULL, 1, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (7, 2, 'Personal Information', 'basic_info', 'Date of Birth', 'date', NULL, NULL, NULL, 1, 4, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (8, 2, 'Personal Information', 'basic_info', 'Gender', 'single_select', '[\"Male\", \"Female\", \"Other\", \"Prefer not to say\"]', NULL, NULL, 1, 5, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (9, 2, 'Personal Information', 'basic_info', 'Nationality', 'text', NULL, NULL, NULL, 1, 6, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (10, 2, 'Personal Information', 'basic_info', 'Country of Birth', 'text', NULL, NULL, NULL, 1, 7, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (11, 2, 'Personal Information', 'basic_info', 'Marital Status', 'single_select', '[\"Single\", \"Married\", \"Divorced\", \"Widowed\"]', NULL, NULL, 0, 8, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (12, 2, 'Personal Information', 'identification', 'Passport Number (if international)', 'text', NULL, NULL, NULL, 0, 9, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (13, 2, 'Personal Information', 'identification', 'National ID Number', 'text', NULL, NULL, NULL, 1, 10, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (14, 3, 'Contact Information', 'address', 'Country', 'text', NULL, NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (15, 3, 'Contact Information', 'address', 'Region/State', 'text', NULL, NULL, NULL, 1, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (16, 3, 'Contact Information', 'address', 'City', 'text', NULL, NULL, NULL, 1, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (17, 3, 'Contact Information', 'address', 'Postal Code', 'text', NULL, NULL, NULL, 0, 4, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (18, 3, 'Contact Information', 'contact', 'Email Address', 'email', NULL, NULL, NULL, 1, 5, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (19, 3, 'Contact Information', 'contact', 'Phone Number', 'phone', NULL, NULL, NULL, 1, 6, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (20, 3, 'Contact Information', 'emergency', 'Emergency Contact Name', 'text', NULL, NULL, NULL, 1, 7, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (21, 3, 'Contact Information', 'emergency', 'Emergency Contact Relationship', 'text', NULL, NULL, NULL, 1, 8, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (22, 3, 'Contact Information', 'emergency', 'Emergency Contact Phone', 'phone', NULL, NULL, NULL, 1, 9, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (23, 4, 'Academic History', 'qualifications', 'Select your qualification type', 'single_select', '[\"WASSCE\", \"A-Level\"]', NULL, NULL, 1, 2, 1, '2025-07-19 01:19:45', '2025-08-14 00:11:22', 0);
INSERT INTO `questions` VALUES (24, 4, 'Academic History', 'wassce_subjects', 'WASSCE Subjects and Grades', 'textarea', NULL, NULL, NULL, 0, 3, 0, '2025-07-19 01:19:45', '2025-08-14 00:11:22', 0);
INSERT INTO `questions` VALUES (25, 4, 'Academic History', 'university', 'University GPA (if applicable)', 'number', NULL, NULL, NULL, 0, 4, 1, '2025-07-19 01:19:45', '2025-08-14 00:11:22', 0);
INSERT INTO `questions` VALUES (26, 4, 'Academic History', 'documents', 'Upload Academic Certificates/Transcripts', 'file', NULL, NULL, NULL, 1, 5, 1, '2025-07-19 01:19:45', '2025-08-14 00:11:22', 0);
INSERT INTO `questions` VALUES (27, 5, 'Program Details', 'program', 'Level of Study', 'single_select', '[\"Certificate\", \"Diploma\", \"Bachelor\'s\", \"Higher Diploma\"]', NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (28, 5, 'Program Details', 'program', 'Program of Study', 'single_select', '[\"State Registered Nurse (SRN)\", \"Community Health Officer (CHO)\", \"Nursing Assistant\"]', NULL, NULL, 1, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (29, 5, 'Program Details', 'program', 'Mode of Study', 'single_select', '[\"Full-time\", \"Part-time\", \"Distance Learning\", \"Online\"]', NULL, NULL, 1, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (30, 6, 'Supporting Documents', 'documents', 'Passport-size Photo', 'file', NULL, NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (31, 6, 'Supporting Documents', 'documents', 'Copy of ID or Passport', 'file', NULL, NULL, NULL, 1, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (32, 6, 'Supporting Documents', 'documents', 'Curriculum Vitae (CV)', 'file', NULL, NULL, NULL, 1, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (33, 6, 'Supporting Documents', 'documents', 'Personal Statement/Motivation Letter', 'file', NULL, NULL, NULL, 1, 4, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (34, 6, 'Supporting Documents', 'documents', 'Letters of Recommendation', 'file', NULL, NULL, NULL, 0, 5, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (38, 8, 'Financial Information', 'funding', 'Method of Funding', 'single_select', '[\"Self-funded\", \"Sponsor\", \"Government Scholarship\", \"Student Loan\", \"Other\"]', NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (39, 8, 'Financial Information', 'sponsor', 'Sponsor Name (if applicable)', 'text', NULL, NULL, NULL, 0, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (40, 8, 'Financial Information', 'sponsor', 'Sponsor Relationship', 'text', NULL, NULL, NULL, 0, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (41, 9, 'Additional Information', 'motivation', 'Why did you choose this university/program?', 'textarea', NULL, NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (42, 9, 'Additional Information', 'motivation', 'How did you hear about this institution?', 'single_select', '[\"Website\", \"Social Media\", \"Friend/Family\", \"Advertisement\", \"Education Fair\", \"Other\"]', NULL, NULL, 0, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (43, 9, 'Additional Information', 'disclosure', 'Do you have any criminal convictions?', 'single_select', '[\"Yes\", \"No\"]', NULL, NULL, 0, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (44, 9, 'Additional Information', 'support', 'Do you have any disabilities or medical conditions requiring support?', 'textarea', NULL, NULL, NULL, 0, 4, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (45, 10, 'Declarations & Agreements', 'agreements', 'I agree to the university policies and terms', 'single_select', '[\"Yes\", \"No\"]', NULL, NULL, 1, 1, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (46, 10, 'Declarations & Agreements', 'agreements', 'I declare that all information provided is accurate and complete', 'single_select', '[\"Yes\", \"No\"]', NULL, NULL, 1, 2, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (47, 10, 'Declarations & Agreements', 'signature', 'Digital Signature (Full Name)', 'text', NULL, NULL, NULL, 1, 3, 1, '2025-07-19 01:19:45', '2025-07-19 01:45:25', 0);
INSERT INTO `questions` VALUES (48, 4, 'Academic History', 'schools', 'Schools Attended', 'table', NULL, NULL, NULL, 1, 1, 1, '2025-08-14 00:08:31', '2025-08-14 00:08:31', 4);
INSERT INTO `questions` VALUES (49, 7, 'Work Experience', 'employment', 'Employment History (if applicable)', 'table', NULL, NULL, NULL, 0, 1, 1, '2025-08-14 00:11:27', '2025-08-14 00:11:27', 7);
INSERT INTO `questions` VALUES (50, 4, 'Employment History', 'employment', 'Employment History', 'table', NULL, NULL, NULL, 1, 2, 1, '2025-08-14 00:15:23', '2025-08-14 00:15:23', 4);
INSERT INTO `questions` VALUES (51, 9, 'Additional Information', 'references', 'References (at least 2)', 'table', NULL, NULL, NULL, 1, 5, 1, '2025-08-14 00:16:07', '2025-08-14 00:16:07', 9);
INSERT INTO `questions` VALUES (52, 4, 'References', 'references', 'References', 'table', NULL, NULL, NULL, 1, 3, 1, '2025-08-14 00:19:16', '2025-08-14 00:19:16', 4);
INSERT INTO `questions` VALUES (55, 8, 'Financial Information', 'sponsor', 'Sponsor Email (if applicable)', 'email', NULL, NULL, NULL, 0, 4, 1, '2025-08-14 00:21:05', '2025-08-14 00:21:05', 8);
INSERT INTO `questions` VALUES (56, 8, 'Financial Information', 'sponsor', 'Sponsor Phone Number (if applicable)', 'phone', NULL, NULL, NULL, 0, 5, 1, '2025-08-14 00:21:05', '2025-08-14 00:21:05', 8);

-- ----------------------------
-- Table structure for user_profiles
-- ----------------------------
DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `user_profiles`  (
  `user_id` int NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` json NULL,
  `date_of_birth` date NULL DEFAULT NULL,
  `nationality` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `emergency_contact` json NULL,
  `sponsor` json NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_profiles
-- ----------------------------
INSERT INTO `user_profiles` VALUES (4, 'Emmanuel', 'Koroma', '078618435', '{\"town\": \"Bo\", \"country\": \"Sierra Leone\", \"district\": \"Bo\", \"province\": \"Southern\"}', '2025-06-02', 'Sierra Leonean', '{\"name\": \"Betty Mohamed\", \"phone\": \"076632358\"}', NULL, NULL);
INSERT INTO `user_profiles` VALUES (5, 'Kinta', 'Johnson', NULL, 'null', NULL, NULL, '{\"name\": \"Aunty K\", \"phone\": \"03086342\"}', NULL, NULL);
INSERT INTO `user_profiles` VALUES (7, 'Abu', 'Kamara', '+23278618435', '{\"city\": \"Bo\", \"street\": \"6 Hancil Road\", \"country\": \"Sierra Leone\", \"district\": \"Bo\"}', '2025-08-06', 'Sierra Leonean', '{\"name\": \"Abu Koroma\", \"phone\": \"078618435\"}', NULL, NULL);
INSERT INTO `user_profiles` VALUES (8, 'Emmanuel', 'Koroma', '+23278618435', '{\"city\": \"Bo\", \"street\": \"6 Hancil Road\", \"country\": \"Sierra Leone\", \"district\": \"Bo\"}', '2025-08-12', 'Sierra Leonean', '{\"name\": \"Abu Kamara\", \"phone\": \"678899\"}', NULL, NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` enum('applicant','principal','finance','it','bank','registrar') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` enum('active','inactive','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending',
  `verification_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password_reset_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (4, 'koromaemmanuel66@gmail.com', '$2y$10$0oqD63KcFxEJQ7iOVVgOr.N4ZeJfu//NjoO9VQLnOCvABMvvXi2a.', 'principal', 'active', NULL, '2025-06-04 00:11:31', '2025-08-10 00:40:09', 'cca7d107eaad60cb3027e5e79f272147ecb8bb248bfe1dca37b641cbfde25be9');
INSERT INTO `users` VALUES (5, 'kintadanielj@gmail.com', '$2y$10$Ppn3Doh.OKznhYY1T2oBuuiqioRyD2P9w9Su/5yDZ7q7Kusu66oka', 'applicant', 'pending', 'b4936493d390d5fe24f533589969d8c98223fb888c41d76f85e8bcfcea90a578', '2025-06-13 11:58:51', '2025-06-13 11:58:51', NULL);
INSERT INTO `users` VALUES (7, 'e34koroma@njala.edu.sl', '$2y$10$qa6HJB0yV/b0I2WtefTvB.6NBFUw/RQbZJfoYIwcZPGc6WC91KRaq', 'applicant', 'active', NULL, '2025-08-09 10:11:35', '2025-08-09 10:13:52', NULL);
INSERT INTO `users` VALUES (8, 'sabiteck2024@gmail.com', '$2y$10$mymYvXaGxuRHbxSbABeUSeoHVFX9E6k4mpaROseC4bUO5xceQ/D3.', 'applicant', 'active', NULL, '2025-08-13 13:45:23', '2025-08-13 13:48:26', NULL);

-- ----------------------------
-- Table structure for wassce_sittings
-- ----------------------------
DROP TABLE IF EXISTS `wassce_sittings`;
CREATE TABLE `wassce_sittings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `sitting_number` int NOT NULL,
  `results` json NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `application_id`(`application_id` ASC) USING BTREE,
  CONSTRAINT `wassce_sittings_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wassce_sittings
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
