--
-- PostgreSQL database dump
--

\restrict u92HazasxOpXMg7ZAsHSY5TnHThxDlngNTs26INpKzqBXd6wjnu5U1Aim0oQur7

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-17 17:32:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 24878)
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    attendance_id integer NOT NULL,
    session_id integer NOT NULL,
    enrollment_no character varying(50) NOT NULL,
    status character varying(10) NOT NULL,
    marked_at time without time zone
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24877)
-- Name: attendance_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_attendance_id_seq OWNER TO postgres;

--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 229
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;


--
-- TOC entry 228 (class 1259 OID 24858)
-- Name: attendance_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_session (
    session_id integer NOT NULL,
    assignment_id integer NOT NULL,
    session_token character varying(50) NOT NULL,
    session_date date NOT NULL,
    started_at time without time zone NOT NULL,
    closed_at time without time zone,
    status character varying(10) NOT NULL
);


ALTER TABLE public.attendance_session OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24857)
-- Name: attendance_session_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_session_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_session_session_id_seq OWNER TO postgres;

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 227
-- Name: attendance_session_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_session_session_id_seq OWNED BY public.attendance_session.session_id;


--
-- TOC entry 223 (class 1259 OID 24802)
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    class_id integer NOT NULL,
    branch character varying(50) NOT NULL,
    section character varying(50) NOT NULL
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24801)
-- Name: classes_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classes_class_id_seq OWNER TO postgres;

--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 222
-- Name: classes_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_class_id_seq OWNED BY public.classes.class_id;


--
-- TOC entry 221 (class 1259 OID 24793)
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    faculty_id integer NOT NULL,
    teacher_name character varying(100) NOT NULL,
    email character varying(50),
    password_hash text
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24792)
-- Name: faculty_faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_faculty_id_seq OWNER TO postgres;

--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 220
-- Name: faculty_faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_faculty_id_seq OWNED BY public.faculty.faculty_id;


--
-- TOC entry 226 (class 1259 OID 24841)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    enrollment_no character varying(20) NOT NULL,
    student_name character varying(50) NOT NULL,
    roll_no integer NOT NULL,
    class_id integer NOT NULL,
    lab_batch character varying(50),
    password_hash text
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24770)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    subject_id character varying(20) NOT NULL,
    subject_name character varying(100) NOT NULL
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24812)
-- Name: teaching_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teaching_assignment (
    assignment_id integer NOT NULL,
    faculty_id integer NOT NULL,
    class_id integer NOT NULL,
    subject_id character varying(20) NOT NULL,
    class_day character varying(20) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    room_no character varying(20) NOT NULL,
    lab_batch character varying(50)
);


ALTER TABLE public.teaching_assignment OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24811)
-- Name: teaching_assignment_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teaching_assignment_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teaching_assignment_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 224
-- Name: teaching_assignment_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teaching_assignment_assignment_id_seq OWNED BY public.teaching_assignment.assignment_id;


--
-- TOC entry 4888 (class 2604 OID 24881)
-- Name: attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);


--
-- TOC entry 4887 (class 2604 OID 24861)
-- Name: attendance_session session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_session ALTER COLUMN session_id SET DEFAULT nextval('public.attendance_session_session_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 24805)
-- Name: classes class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN class_id SET DEFAULT nextval('public.classes_class_id_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 24796)
-- Name: faculty faculty_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN faculty_id SET DEFAULT nextval('public.faculty_faculty_id_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 24815)
-- Name: teaching_assignment assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaching_assignment ALTER COLUMN assignment_id SET DEFAULT nextval('public.teaching_assignment_assignment_id_seq'::regclass);


--
-- TOC entry 4908 (class 2606 OID 24887)
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- TOC entry 4910 (class 2606 OID 24889)
-- Name: attendance attendance_session_id_enrollment_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_session_id_enrollment_no_key UNIQUE (session_id, enrollment_no);


--
-- TOC entry 4904 (class 2606 OID 24869)
-- Name: attendance_session attendance_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_session
    ADD CONSTRAINT attendance_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 4906 (class 2606 OID 24871)
-- Name: attendance_session attendance_session_session_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_session
    ADD CONSTRAINT attendance_session_session_token_key UNIQUE (session_token);


--
-- TOC entry 4896 (class 2606 OID 24810)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- TOC entry 4892 (class 2606 OID 32952)
-- Name: faculty faculty_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_email_key UNIQUE (email);


--
-- TOC entry 4894 (class 2606 OID 24800)
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (faculty_id);


--
-- TOC entry 4900 (class 2606 OID 24849)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (enrollment_no);


--
-- TOC entry 4902 (class 2606 OID 24851)
-- Name: students students_roll_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_roll_no_key UNIQUE (roll_no);


--
-- TOC entry 4890 (class 2606 OID 24776)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (subject_id);


--
-- TOC entry 4898 (class 2606 OID 24825)
-- Name: teaching_assignment teaching_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaching_assignment
    ADD CONSTRAINT teaching_assignment_pkey PRIMARY KEY (assignment_id);


--
-- TOC entry 4916 (class 2606 OID 24895)
-- Name: attendance attendance_enrollment_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_enrollment_no_fkey FOREIGN KEY (enrollment_no) REFERENCES public.students(enrollment_no);


--
-- TOC entry 4915 (class 2606 OID 24872)
-- Name: attendance_session attendance_session_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_session
    ADD CONSTRAINT attendance_session_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.teaching_assignment(assignment_id);


--
-- TOC entry 4917 (class 2606 OID 24890)
-- Name: attendance attendance_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.attendance_session(session_id);


--
-- TOC entry 4914 (class 2606 OID 24852)
-- Name: students students_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- TOC entry 4911 (class 2606 OID 24831)
-- Name: teaching_assignment teaching_assignment_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaching_assignment
    ADD CONSTRAINT teaching_assignment_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- TOC entry 4912 (class 2606 OID 24826)
-- Name: teaching_assignment teaching_assignment_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaching_assignment
    ADD CONSTRAINT teaching_assignment_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id);


--
-- TOC entry 4913 (class 2606 OID 24836)
-- Name: teaching_assignment teaching_assignment_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaching_assignment
    ADD CONSTRAINT teaching_assignment_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id);


-- Completed on 2026-10-17 17:32:47

--
-- PostgreSQL database dump complete
--

\unrestrict u92HazasxOpXMg7ZAsHSY5TnHThxDlngNTs26INpKzqBXd6wjnu5U1Aim0oQur7

