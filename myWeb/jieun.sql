CREATE TABLE customer (
	id		NUMBER CONSTRAINT customer_id_pk PRIMARY KEY,
	name	VARCHAR2(50) NOT NULL,
	gender	VARCHAR2(3) NOT NULL,
	email	VARCHAR2(50),
	phone	VARCHAR2(13)
);

CREATE SEQUENCE seq_customer START WITH 1 INCREMENT BY 1;

--���ڵ� ����
INSERT INTO customer(id, name, gender)
VALUES (seq_customer.NEXTVAL, 'ȫ�浿', '��');
INSERT INTO customer(id, name, gender)
VALUES (seq_customer.NEXTVAL, '��û', '��');

drop trigger trg_customer;

CREATE OR REPLACE TRIGGER trg_customer
    BEFORE INSERT ON customer
    FOR EACH ROW
BEGIN
    SELECT seq_customer.NEXTVAL INTO :new.id FROM dual;
END;
/

SELECT * FROM customer;

COMMIT;

--ȸ�� ���� ���̺�

CREATE TABLE member(
    irum    VARCHAR2(20)    NOT NULL,
    id      VARCHAR2(20)    CONSTRAINT member_id_pk PRIMARY KEY,
    pw      VARCHAR2(20)    NOT NULL,
    age     NUMBER,
    gender  VARCHAR2(3)     NOT NULL,
    birth   DATE,
    post    VARCHAR2(7),
    addr    VARCHAR2(50),
    email   VARCHAR2(50)    NOT NULL,   --����ũ�� ���� �����ϰ� NOT NULL�� ����
    tel     VARCHAR2(20),
    admin   VARCHAR2(1)     DEFAULT 'N'
);

--������ �ִ� member ���̺� ����
ALTER TABLE member
MODIFY(
    gender  VARCHAR2(3) DEFAULT '��',
    birth   DATE,
    post    VARCHAR2(7),
    email   VARCHAR2(50) NULL,
    admin   VARCHAR2(1) default 'N'
);

UPDATE MEMBER SET email = id || '@naver.com';

ALTER TABLE member
MODIFY (email NOT NULL);

ALTER TABLE member RENAME COLUMN irum TO name;

ALTER TABLE member ADD CONSTRAINT member_id_pk PRIMARY KEY(id);

--������ ȸ�� ���� ����
INSERT INTO member(name, id, pw, age, gender, email, admin)
VALUES ('������', 'admin', '1234', 25, '��', 'admin@admin.com', 'Y');

SELECT * FROM member;

--20/07/10======================================================================
CREATE TABLE notice(
    id          NUMBER CONSTRAINT notice_id_pk PRIMARY KEY,
    title       VARCHAR2(300) NOT NULL,
    content     VARCHAR2(4000) NOT NULL,
    writer      VARCHAR2(20) NOT NULL,
    writedate   DATE DEFAULT SYSDATE,
    readcnt     NUMBER DEFAULT 0,
    filename    VARCHAR2(300),
    filepath    VARCHAR2(300)
);

CREATE SEQUENCE seq_notice
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_notice
    BEFORE INSERT ON notice
    FOR EACH ROW
BEGIN
    SELECT seq_notice.NEXTVAL INTO:NEW.id FROM dual;
END;
/

SELECT * FROM notice;

INSERT INTO notice(title, content, writer)
VALUES ('���� �� �׽�Ʈ', '�׽�Ʈ ���� �� �Դϴ�.', 'admin');

COMMIT;

--���̺� ������ �׸� �߰�
INSERT INTO notice(title, content ,writer, writedate, filepath, filename)
SELECT title, content, writer, writedate, filepath, filename FROM notice;

--notice ���̺� Į�� �߰�
CREATE TABLE notice(
    id          NUMBER CONSTRAINT notice_id_pk PRIMARY KEY,
    title       VARCHAR2(300) NOT NULL,
    content     VARCHAR2(4000) NOT NULL,
    writer      VARCHAR2(20) NOT NULL,
    writedate   DATE DEFAULT SYSDATE,
    readcnt     NUMBER DEFAULT 0,
    filename    VARCHAR2(300),
    filepath    VARCHAR2(300),
    root        NUMBER,
    step        NUMBER default 0,
    indent      NUMBER default 0 
);

ALTER TABLE notice
ADD(root NUMBER, step NUMBER DEFAULT 0, indent NUMBER DEFAULT 0);

UPDATE notice SET root = id;

ALTER TRIGGER trg_notice DISABLE;

COMMIT;


INSERT INTO member(id, pw, gender, email, name, admin)
VALUES ('admin2', '1234', '��', 'admin2@admin@.com', '���', 'Y');

UPDATE notice SET writer='admin2'
WHERE mod(id, 3) = 0;

--qna ���̺� ����
CREATE TABLE qna(
    id          NUMBER CONSTRAINT qna_id_pk PRIMARY KEY,
    title       VARCHAR2(300) NOT NULL,
    content     VARCHAR2(4000) NOT NULL,
    writer      VARCHAR2(20) NOT NULL,
    writedate   DATE DEFAULT SYSDATE,
    readcnt     NUMBER DEFAULT 0,
    filename    VARCHAR2(300),
    filepath    VARCHAR2(300),
    root        NUMBER,
    step        NUMBER default 0,
    indent      NUMBER default 0 
);

CREATE SEQUENCE seq_qna
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_qna
    BEFORE INSERT ON qna
    FOR EACH ROW
BEGIN
    SELECT seq_qna.NEXTVAL INTO:NEW.id FROM dual;
END;
/

INSERT INTO qna (id, title, content, writer)
VALUES (1, 'ù �� �׽�Ʈ', 'testcontext', '������');

UPDATE qna SET root = id;

SELECT * FROM qna;


--���� ����
CREATE TABLE board(
	id			NUMBER			CONSTRAINT board_id_pk PRIMARY KEY,
	title		VARCHAR2(300)	NOT NULL,
	content		VARCHAR2(4000)	NOT NULL,
	writer		VARCHAR2(100)	NOT NULL,
	writedate	DATE DEFAULT SYSDATE,
	readcnt		NUMBER DEFAULT 0,
	filename	VARCHAR2(300),
	filepath	VARCHAR2(300)
);

CREATE SEQUENCE seq_board START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_board
	BEFORE INSERT ON board
	FOR EACH ROW
BEGIN
	SELECT seq_board.NEXTVAL INTO :new.id FROM dual;
END;
/

COMMIT;

INSERT INTO board (title, content, writer, filename, filepath)
SELECT title, content, writer, filename, filepath
FROM board;


CREATE TABLE board_comment (
	id NUMBER constraint board_comment_id_pk PRIMARY KEY,
	pid NUMBER NOT NULL, /* ������ ���̵� */
	writer VARCHAR2(20) NOT NULL, /* ��� �ۼ��� ���̵� */
	content VARCHAR2(4000) NOT NULL,
    writedate DATE DEFAULT SYSDATE,
    CONSTRAINT board_comment_pid_fk FOREIGN KEY(pid) REFERENCES board(id) ON DELETE CASCADE,
    CONSTRAINT board_comment_writer_fk FOREIGN KEY(writer) REFERENCES member(id) ON DELETE CASCADE
);

CREATE SEQUENCE seq_board_comment
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_board_comment
    BEFORE INSERT ON board_comment
    FOR EACH ROW
BEGIN
    SELECT seq_board_comment.NEXTVAL INTO :NEW.id FROM dual;
END;
/

COMMIT;

SELECT * FROM board_comment;