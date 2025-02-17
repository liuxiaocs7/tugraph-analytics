CREATE TABLE IF NOT EXISTS tbl_result_04 (
	s_id bigint,
	c_id bigint,
  c_name varchar,
  t_id bigint
) WITH (
	type='file',
	geaflow.dsl.file.path='${target}'
);

USE GRAPH g_student;

INSERT INTO tbl_result_04
SELECT sc.srcId, c.id, c.name, hasTeacher.targetId
FROM selectCourse sc, course c, hasTeacher
WHERE c.id = sc.targetId AND c.id = hasTeacher.srcId AND sc.srcId < 1004
ORDER BY sc.srcId, sc.targetId
;