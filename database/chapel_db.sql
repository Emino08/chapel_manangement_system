/*
 Navicat Premium Dump SQL

 Source Server         : Mattru Nursing
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:4306
 Source Schema         : chapel_db

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 02/10/2025 18:56:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attendance
-- ----------------------------
DROP TABLE IF EXISTS `attendance`;
CREATE TABLE `attendance`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PRESENT','ABSENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `marked_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_service_student`(`service_id` ASC, `student_id` ASC) USING BTREE,
  INDEX `marked_by`(`marked_by` ASC) USING BTREE,
  INDEX `idx_service`(`service_id` ASC) USING BTREE,
  INDEX `idx_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `attendance_ibfk_3` FOREIGN KEY (`marked_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attendance
-- ----------------------------
INSERT INTO `attendance` VALUES ('06594af0-d501-4d09-aa07-9f50910a4281', '14d4a632-9f72-11f0-8561-745d227c4049', '8db9c347-4fe4-47f4-b9db-7d8565e8838d', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:34:07', '2025-10-02 16:34:07');
INSERT INTO `attendance` VALUES ('14de2e25-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8fd3d-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14deacd5-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d902c6-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14deb596-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8d017-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14debb47-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8d3c8-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14debfea-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8d750-9f72-11f0-8561-745d227c4049', 'ABSENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14dec4ab-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8db1f-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14dec94f-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8e309-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14decfc7-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8eb05-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14ded511-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8ef1e-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14ded9e8-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8f52b-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14dede33-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8f956-9f72-11f0-8561-745d227c4049', 'ABSENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14dee25a-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d71384-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14dee697-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8aa2f-9f72-11f0-8561-745d227c4049', 'ABSENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14deeb21-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8b12b-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('14def021-9f72-11f0-8561-745d227c4049', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8b577-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `attendance` VALUES ('629f65a4-966f-4cce-bf87-e1abb05b6e3c', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8bd73-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:31:19', '2025-10-02 16:31:19');
INSERT INTO `attendance` VALUES ('6817762b-a1f2-4595-ab14-beafd6231afc', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8b968-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:26:38', '2025-10-02 16:26:38');
INSERT INTO `attendance` VALUES ('8c162223-5f5b-494d-8de4-e3a6c5a7ea5d', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8c574-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:34:03', '2025-10-02 16:34:03');
INSERT INTO `attendance` VALUES ('c99fe67a-c93c-460e-8581-a1fc68cbcfd0', '14d4a632-9f72-11f0-8561-745d227c4049', '14d8cc0a-9f72-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:34:05', '2025-10-02 16:34:05');

-- ----------------------------
-- Table structure for lecturer_attendance
-- ----------------------------
DROP TABLE IF EXISTS `lecturer_attendance`;
CREATE TABLE `lecturer_attendance`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lecturer_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PRESENT','ABSENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `marked_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_service_lecturer`(`service_id` ASC, `lecturer_id` ASC) USING BTREE,
  INDEX `marked_by`(`marked_by` ASC) USING BTREE,
  INDEX `idx_service`(`service_id` ASC) USING BTREE,
  INDEX `idx_lecturer`(`lecturer_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `lecturer_attendance_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `lecturer_attendance_ibfk_2` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `lecturer_attendance_ibfk_3` FOREIGN KEY (`marked_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lecturer_attendance
-- ----------------------------
INSERT INTO `lecturer_attendance` VALUES ('116f470f-8a28-422d-a006-9ca29d7a4c79', '14d4a632-9f72-11f0-8561-745d227c4049', '679d7848-9fa4-11f0-8561-745d227c4049', 'ABSENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:25:12', '2025-10-02 16:25:12');
INSERT INTO `lecturer_attendance` VALUES ('13877ccf-83a7-4eba-9174-4dc686690f2d', '14d4a632-9f72-11f0-8561-745d227c4049', '679d81ea-9fa4-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:26:20', '2025-10-02 16:26:20');
INSERT INTO `lecturer_attendance` VALUES ('5160a717-e831-4574-bf82-70d08b45eceb', '14d4a632-9f72-11f0-8561-745d227c4049', '679d8622-9fa4-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:34:17', '2025-10-02 16:34:17');
INSERT INTO `lecturer_attendance` VALUES ('629d6841-003e-4474-8372-ab376fa27d7a', '14d4a632-9f72-11f0-8561-745d227c4049', '679d69b5-9fa4-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:24:34', '2025-10-02 16:24:34');
INSERT INTO `lecturer_attendance` VALUES ('f8ceab96-dff6-4698-8f1c-604b936544fb', '14d4a632-9f72-11f0-8561-745d227c4049', '679d7e1a-9fa4-11f0-8561-745d227c4049', 'PRESENT', '14c61311-9f72-11f0-8561-745d227c4049', '2025-10-02 16:26:17', '2025-10-02 16:26:17');

-- ----------------------------
-- Table structure for lecturers
-- ----------------------------
DROP TABLE IF EXISTS `lecturers`;
CREATE TABLE `lecturers`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lecturer_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `faculty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `position` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `lecturer_no`(`lecturer_no` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_lecturer_no`(`lecturer_no` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_department`(`department` ASC) USING BTREE,
  INDEX `idx_faculty`(`faculty` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lecturers
-- ----------------------------
INSERT INTO `lecturers` VALUES ('679d69b5-9fa4-11f0-8561-745d227c4049', 'LEC2025001', 'Dr. Mohamed Kamara', 'Computer Science', 'Engineering & Technology', '+232-78-111111', 'mkamara@university.sl', 'Senior Lecturer', '2025-10-02 15:28:11', '2025-10-02 15:28:11');
INSERT INTO `lecturers` VALUES ('679d7848-9fa4-11f0-8561-745d227c4049', 'LEC2025002', 'Prof. Fatmata Sesay', 'Business Administration', 'Business & Economics', '+232-78-222222', 'fsesay@university.sl', 'Professor', '2025-10-02 15:28:11', '2025-10-02 15:28:11');
INSERT INTO `lecturers` VALUES ('679d7e1a-9fa4-11f0-8561-745d227c4049', 'LEC2025003', 'Dr. Ibrahim Koroma', 'Civil Engineering', 'Engineering & Technology', '+232-78-333333', 'ikoroma@university.sl', 'Associate Professor', '2025-10-02 15:28:11', '2025-10-02 15:28:11');
INSERT INTO `lecturers` VALUES ('679d81ea-9fa4-11f0-8561-745d227c4049', 'LEC2025004', 'Ms. Aminata Bangura', 'Nursing', 'Health Sciences', '+232-78-444444', 'abangura@university.sl', 'Lecturer', '2025-10-02 15:28:11', '2025-10-02 15:28:11');
INSERT INTO `lecturers` VALUES ('679d8622-9fa4-11f0-8561-745d227c4049', 'LEC2025005', 'Dr. Joseph Jalloh', 'Law', 'Law & Political Science', '+232-78-555555', 'jjalloh@university.sl', 'Senior Lecturer', '2025-10-02 15:28:11', '2025-10-02 15:28:11');

-- ----------------------------
-- Table structure for pastors
-- ----------------------------
DROP TABLE IF EXISTS `pastors`;
CREATE TABLE `pastors`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `program` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_code`(`code` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pastors
-- ----------------------------
INSERT INTO `pastors` VALUES ('14d06ce3-9f72-11f0-8561-745d227c4049', 'PST001', 'Rev. John Wesley', 'Theology & Missions', '+232-76-123456', '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `pastors` VALUES ('14d07305-9f72-11f0-8561-745d227c4049', 'PST002', 'Pastor Sarah Johnson', 'Biblical Studies', '+232-76-234567', '2025-10-02 09:27:57', '2025-10-02 09:27:57');

-- ----------------------------
-- Table structure for semesters
-- ----------------------------
DROP TABLE IF EXISTS `semesters`;
CREATE TABLE `semesters`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `active` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dates`(`start_date` ASC, `end_date` ASC) USING BTREE,
  INDEX `idx_active`(`active` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of semesters
-- ----------------------------
INSERT INTO `semesters` VALUES ('c8f09794-9f8b-11f0-8561-745d227c4049', 'First Semester', '2025-09-01', '2025-12-20', 1, '2025-10-02 12:31:56', '2025-10-02 12:31:56');
INSERT INTO `semesters` VALUES ('c8f0a585-9f8b-11f0-8561-745d227c4049', 'Second Semester', '2026-01-15', '2026-05-15', 0, '2025-10-02 12:31:56', '2025-10-02 12:31:56');

-- ----------------------------
-- Table structure for services
-- ----------------------------
DROP TABLE IF EXISTS `services`;
CREATE TABLE `services`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_date` date NOT NULL,
  `start_time` time NOT NULL DEFAULT '09:00:00',
  `end_time` time NOT NULL DEFAULT '12:00:00',
  `theme` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `pastor_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `service_date`(`service_date` ASC) USING BTREE,
  INDEX `pastor_id`(`pastor_id` ASC) USING BTREE,
  INDEX `idx_service_date`(`service_date` ASC) USING BTREE,
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`pastor_id`) REFERENCES `pastors` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of services
-- ----------------------------
INSERT INTO `services` VALUES ('14d4a632-9f72-11f0-8561-745d227c4049', '2025-10-01', '09:00:00', '12:00:00', 'Faith and Excellence in Academic Life', '14d06ce3-9f72-11f0-8561-745d227c4049', '2025-10-02 09:27:57', '2025-10-02 09:27:57');

-- ----------------------------
-- Table structure for students
-- ----------------------------
DROP TABLE IF EXISTS `students`;
CREATE TABLE `students`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `program` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `faculty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `student_id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `student_no`(`student_no` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_program`(`program` ASC) USING BTREE,
  INDEX `idx_faculty`(`faculty` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of students
-- ----------------------------
INSERT INTO `students` VALUES ('14d71384-9f72-11f0-8561-745d227c4049', 'S2025001', 'Abdul Rahman Kamara', 'Computer Science', 'Engineering & Technology', '+232-77-111111', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8aa2f-9f72-11f0-8561-745d227c4049', 'S2025002', 'Mariama Sesay', 'Business Administration', 'Business & Economics', '+232-77-222222', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8b12b-9f72-11f0-8561-745d227c4049', 'S2025003', 'Ibrahim Koroma', 'Civil Engineering', 'Engineering & Technology', '+232-77-333333', 'Year 3', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8b577-9f72-11f0-8561-745d227c4049', 'S2025004', 'Fatmata Bangura', 'Nursing', 'Health Sciences', '+232-77-444444', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8b968-9f72-11f0-8561-745d227c4049', 'S2025005', 'Mohamed Jalloh', 'Law', 'Law & Political Science', '+232-77-555555', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8bd73-9f72-11f0-8561-745d227c4049', 'S2025006', 'Aminata Conteh', 'Mass Communication', 'Arts & Humanities', '+232-77-666666', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8c574-9f72-11f0-8561-745d227c4049', 'S2025008', 'Hawa Turay', 'Economics', 'Business & Economics', '+232-77-888888', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8cc0a-9f72-11f0-8561-745d227c4049', 'S2025009', 'Sahr Kamanda', 'Computer Science', 'Engineering & Technology', '+232-77-999999', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8d017-9f72-11f0-8561-745d227c4049', 'S2025010', 'Jenneh Koroma', 'Public Health', 'Health Sciences', '+232-76-111222', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8d3c8-9f72-11f0-8561-745d227c4049', 'S2025011', 'Abubakarr Barrie', 'Accounting', 'Business & Economics', '+232-76-222333', 'Year 3', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8d750-9f72-11f0-8561-745d227c4049', 'S2025012', 'Isatu Kargbo', 'Social Work', 'Arts & Humanities', '+232-76-333444', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8db1f-9f72-11f0-8561-745d227c4049', 'S2025013', 'Brima Dumbuya', 'Mechanical Engineering', 'Engineering & Technology', '+232-76-444555', 'Year 3', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8e309-9f72-11f0-8561-745d227c4049', 'S2025014', 'Kadiatu Bangura', 'Psychology', 'Arts & Humanities', '+232-76-555666', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8eb05-9f72-11f0-8561-745d227c4049', 'S2025015', 'Alimamy Koroma', 'Information Technology', 'Engineering & Technology', '+232-76-666777', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8ef1e-9f72-11f0-8561-745d227c4049', 'S2025016', 'Zainab Sesay', 'International Relations', 'Law & Political Science', '+232-76-777888', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8f52b-9f72-11f0-8561-745d227c4049', 'S2025017', 'Foday Mansaray', 'Banking & Finance', 'Business & Economics', '+232-76-888999', 'Year 3', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8f956-9f72-11f0-8561-745d227c4049', 'S2025018', 'Adama Jalloh', 'Biology', 'Natural Sciences', '+232-76-999000', 'Year 2', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d8fd3d-9f72-11f0-8561-745d227c4049', 'S2025019', 'Musa Kamara', 'Architecture', 'Engineering & Technology', '+232-75-111222', 'Year 3', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('14d902c6-9f72-11f0-8561-745d227c4049', 'S2025020', 'Fatu Koroma', 'Mathematics', 'Natural Sciences', '+232-75-222333', 'Year 1', NULL, '2025-10-02 09:27:57', '2025-10-02 09:27:57');
INSERT INTO `students` VALUES ('8db9c347-4fe4-47f4-b9db-7d8565e8838d', 'S2025101', 'John Doe', 'Software Engineering', 'Engineering & Technology', '+232-78-111222', 'Year 1', NULL, '2025-10-02 10:13:31', '2025-10-02 10:13:31');
INSERT INTO `students` VALUES ('9f3bfa58-a836-4a07-9194-e7091a7b2b60', 'S2025102', 'Jane Smith', 'Mechanical Engineering', 'Engineering & Technology', '+232-78-222333', 'Year 2', NULL, '2025-10-02 10:13:31', '2025-10-02 10:13:31');
INSERT INTO `students` VALUES ('e43f5fcd-b03a-4d22-90f8-d860dc9711e9', 'S2025103', 'Michael Johnson', 'Business Management', 'Business & Economics', '+232-78-333444', 'Year 3', NULL, '2025-10-02 10:13:31', '2025-10-02 10:13:31');
INSERT INTO `students` VALUES ('ea5e736b-20be-4258-993e-0e5ea952f3a7', '32770', 'Emmanuel Koroma', 'BSc in Computer', NULL, '078618435', 'Year 1', NULL, '2025-10-02 11:09:03', '2025-10-02 11:09:03');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('ADMIN','HR','SUO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `must_change_password` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('14c61311-9f72-11f0-8561-745d227c4049', 'System Administrator', 'admin@chapel.local', 'ADMIN', '$2y$10$brnV56BFT5wXMjQuM73YlOkxqv2tPQ5tU7hIuhWh9V/7hk.mLOnc2', 0, '2025-10-02 09:27:57', '2025-10-02 12:08:32');
INSERT INTO `users` VALUES ('3d2153c8-20dc-4fe5-8d89-12c27a80f143', 'Test User', 'testuser@chapel.local', 'HR', '$2y$10$q03P1Cv38B6eavQAP2rVVOYd6Uk/e5jtNyRrRjs9R4bF2V8JCnIeG', 0, '2025-10-02 18:43:52', '2025-10-02 18:44:15');
INSERT INTO `users` VALUES ('4e9d2a87-e8fd-4f3e-bea7-844d4c5f7cac', 'Abu Kamara', 'emo@gmail.com', 'HR', '$2y$10$XAP0nS8.vTfOaqbO.pKfYOMw8bF8HvVFVsH0a4xPulC6dyUGP2td6', 0, '2025-10-02 18:46:34', '2025-10-02 18:53:29');

-- ----------------------------
-- View structure for v_lecturer_semester_attendance
-- ----------------------------
DROP VIEW IF EXISTS `v_lecturer_semester_attendance`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_lecturer_semester_attendance` AS select `s`.`id` AS `semester_id`,`s`.`name` AS `semester_name`,`l`.`id` AS `lecturer_id`,`l`.`lecturer_no` AS `lecturer_no`,`l`.`name` AS `lecturer_name`,`l`.`department` AS `department`,`l`.`faculty` AS `faculty`,`l`.`position` AS `position`,count(distinct (case when (`la`.`status` = 'PRESENT') then `srv`.`id` end)) AS `times_attended`,count(distinct `srv`.`id`) AS `total_services` from (((`semesters` `s` join `lecturers` `l`) left join `services` `srv` on((`srv`.`service_date` between `s`.`start_date` and `s`.`end_date`))) left join `lecturer_attendance` `la` on(((`la`.`service_id` = `srv`.`id`) and (`la`.`lecturer_id` = `l`.`id`)))) group by `s`.`id`,`s`.`name`,`l`.`id`,`l`.`lecturer_no`,`l`.`name`,`l`.`department`,`l`.`faculty`,`l`.`position`;

-- ----------------------------
-- View structure for v_semester_attendance
-- ----------------------------
DROP VIEW IF EXISTS `v_semester_attendance`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_semester_attendance` AS select `s`.`id` AS `semester_id`,`s`.`name` AS `semester_name`,`st`.`id` AS `student_id`,`st`.`student_no` AS `student_no`,`st`.`name` AS `student_name`,`st`.`program` AS `program`,`st`.`faculty` AS `faculty`,`st`.`level` AS `level`,count(distinct (case when (`a`.`status` = 'PRESENT') then `srv`.`id` end)) AS `times_attended`,count(distinct `srv`.`id`) AS `total_services` from (((`semesters` `s` join `students` `st`) left join `services` `srv` on((`srv`.`service_date` between `s`.`start_date` and `s`.`end_date`))) left join `attendance` `a` on(((`a`.`service_id` = `srv`.`id`) and (`a`.`student_id` = `st`.`id`)))) group by `s`.`id`,`s`.`name`,`st`.`id`,`st`.`student_no`,`st`.`name`,`st`.`program`,`st`.`faculty`,`st`.`level`;

SET FOREIGN_KEY_CHECKS = 1;
