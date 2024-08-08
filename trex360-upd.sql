CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
  

SELECT relname, n_live_tup FROM pg_stat_user_tables WHERE n_live_tup <> 0 AND schemaname = 'dbo' ORDER BY n_live_tup DESC;


drop table if exists dbo.ticket_activities;
drop table if exists dbo.tickets;
drop table if exists dbo.ticket_headers;
drop table if exists dbo.product_mapping_redemptions;
drop table if exists dbo.product_mapping_level_sources;
drop table if exists dbo.product_mapping_attribute_sources;
drop table if exists dbo.product_mapping_product_sources; 
drop table if exists dbo.product_mapping_pass_sources;
drop table if exists dbo.product_mappings;
drop table if exists dbo.customers;
drop table if exists dbo.sites;
drop table if exists dbo.ticket_header_alternative_barcodes;
drop table if exists dbo.mapping_types;
drop table if exists dbo.site_systems;    
drop table if exists dbo.ticket_activities;    
		

create table dbo.ticket_header_alternative_barcodes
(
	ticket_header_alternative_barcode_id bigint generated always as identity primary key,
  ticket_header_alternative_barcode_uid UUID not null default uuid_generate_v4(),
  ticket_header_id bigint not null,
  barcode varchar(50) not null 
);
 
create unique index alternative_barcodes_uid_idx on dbo.ticket_header_alternative_barcodes (ticket_header_alternative_barcode_uid);
create index alternative_barcodes_header_idx on dbo.ticket_header_alternative_barcodes (ticket_header_id);
create index alternative_barcodes_brcd_idx on dbo.ticket_header_alternative_barcodes (barcode);
 
truncate table dbo.ticket_header_alternative_barcodes restart identity;
 
			 			 
create table dbo.site_systems
(
	site_system_id int primary key,
  site_system_uid UUID not null default uuid_generate_v4(),
  site_system_code varchar(50) not null,
  site_system_name varchar(100) not null 
);
 
create unique index system_uid_idx on dbo.site_systems (site_system_uid);
create unique index system_code_idx on dbo.site_systems (site_system_code);
 
truncate table dbo.site_systems restart identity;
 

create table dbo.mapping_types
(
	mapping_type_id int generated always as identity primary key,
  mapping_type_uid UUID not null default uuid_generate_v4(),
  mapping_type_code varchar(50) not null,
  mapping_type_name varchar(100) not null 
);
 
create unique index mapping_types_uid_idx on dbo.mapping_types (mapping_type_uid);
create unique index mapping_types_code_idx on dbo.mapping_types (mapping_type_code);
 
truncate table dbo.mapping_types restart identity;
     
		 
create table dbo.customers
(
	customer_id bigint generated always as identity primary key,
  customer_uid UUID not null default uuid_generate_v4(),
  created_date_time timestamp not null default timezone('utc', now()),
  created_by varchar(100) not null,
  updated_date_time timestamp null,
  updated_by varchar(100) null,
  customer_code varchar(50) not null,
  customer_name varchar(100) not null,
  first_name varchar(100) null,
  middle_name varchar(10) null,
  last_name varchar(100) null,
	picture_file varchar(50) null,
  phone1 varchar(20) null,
  phone1_extension varchar(5) null,
  phone2 varchar(20) null,
  phone2_extension varchar(5) null,
  fax varchar(20) null,
  fax_extension varchar(5) null,
  email varchar(100) null,
  address1 varchar(500) null,
  address2 varchar(500) null,
  country varchar(100) null,
  city varchar(100) null,
  state varchar(50) null,
  zip varchar(20) null 
);
 
create unique index customers_uid_idx on dbo.customers (customer_uid);
create unique index customers_code_idx on dbo.customers (customer_code);
create index customers_name_idx on dbo.customers (customer_name);
 
truncate table dbo.customers restart identity;
  
 
create table dbo.sites
(
	site_id int generated always as identity primary key,
  site_uid UUID not null default uuid_generate_v4(),
  site_code varchar(50) not null,
  site_name varchar(100) not null,
  internal_system_site_id int not null,
  internal_system_site_code varchar(10) null,
	site_system_id int not null, 
	
	foreign key (site_system_id) references dbo.site_systems(site_system_id) 
);
 
create unique index sites_site_uid_idx on dbo.sites (site_uid);
create unique index sites_site_code_idx on dbo.sites (site_code);
create index sites_site_number_idx on dbo.sites (internal_system_site_id);
 
truncate table dbo.sites restart identity;
   
	 
create table dbo.ticket_headers
(
	ticket_header_id bigint generated always as identity primary key,
	ticket_header_uid UUID not null default uuid_generate_v4(),
  created_date_time timestamp not null default timezone('utc', now()),
  created_by varchar(100) not null,
  updated_date_time timestamp null,
  updated_by varchar(100) null,
  barcode varchar(50) not null,
  customer_id bigint not null,
   
  foreign key (customer_id) references dbo.customers(customer_id)
);

create unique index ticket_headers_uid_idx on dbo.ticket_headers (ticket_header_uid);
create unique index ticket_headers_barcode_idx on dbo.ticket_headers (barcode);
create index ticket_headers_customer_idx on dbo.ticket_headers (customer_id);

truncate table dbo.ticket_headers restart identity;

 
create table dbo.tickets
(
	ticket_id bigint generated always as identity primary key,
	ticket_uid UUID not null default uuid_generate_v4(),
	
	ticket_code varchar(50) not null,
  created_date_time timestamp not null default timezone('utc', now()),
    
  ticket_header_id bigint not null,
	
  season int null,
	venue varchar(50) null,
	home_site_id int not null,
	
	product_id bigint null,
	product_name varchar(50) null,
	
	product_attribute_id int null,
	product_attribute_name varchar(50) null,
	
	season_pass_type_id int null,
	season_pass_type_name varchar(50) null,
	
  status varchar(50) not null,
  
  start_date date null,
  end_date date null,
   
	product_type_id int null,
	product_type_name varchar(100) null,
	
	product_level_id int null,
	product_level varchar(50) null,
	 
  foreign key (ticket_header_id) references dbo.ticket_headers(ticket_header_id), 
	foreign key (home_site_id) references dbo.sites(site_id) 
);

create unique index tickets_uid_idx on dbo.tickets (ticket_uid);
create unique index tickets_code_idx on dbo.tickets (ticket_code);
create index tickets_header_idx on dbo.tickets (ticket_header_id);
create index tickets_product_idx on dbo.tickets (product_id);
 
truncate table dbo.tickets restart identity;

 
create table dbo.product_mappings
(
	product_mapping_id bigint generated always as identity primary key,
	product_mapping_uid UUID not null default uuid_generate_v4(),
  created_date_time timestamp not null default timezone('utc', now()),
  created_by varchar(100) not null,
  updated_date_time timestamp null,
  updated_by varchar(100) null,
  
	mapping_code varchar(50) not null,
  mapping_name varchar(100) not null,
  mapping_type_id int not null,
   
  foreign key (mapping_type_id) references dbo.mapping_types(mapping_type_id) 
);

create unique index product_mappings_uid_idx on dbo.product_mappings (product_mapping_uid);
create unique index product_mappings_code_idx on dbo.product_mappings (mapping_code);
 
truncate table dbo.product_mappings restart identity;
  
   
create table dbo.product_mapping_product_sources
(
	product_mapping_product_source_id int generated always as identity primary key,
  product_mapping_id int not null,
  home_site_id int not null,
  product_id bigint not null,   			-- ProductNo from GC or ID from SFTS depends on home_site_id
	product_name varchar(100) not null,
		 
	foreign key (product_mapping_id) references dbo.product_mappings(product_mapping_id)
);
 
create index product_mapping_product_sources_mapping_idx on dbo.product_mapping_product_sources (product_mapping_id);
create index product_mapping_product_sources_site_idx on dbo.product_mapping_product_sources (home_site_id);
create index product_mapping_product_sources_prod_idx on dbo.product_mapping_product_sources (product_id);
 
truncate table dbo.product_mapping_product_sources restart identity;
 
 
create table dbo.product_mapping_attribute_sources
(
	product_mapping_attribute_source_id int generated always as identity primary key,
  product_mapping_id int not null,
	product_attribute_id int not null,
  product_attribute_name varchar(50) not null,
	 
	foreign key (product_mapping_id) references dbo.product_mappings(product_mapping_id)
);
 
create index product_mapping_attribute_sources_mapping_idx on dbo.product_mapping_attribute_sources (product_mapping_id);
create index product_mapping_attribute_sources_att_idx on dbo.product_mapping_attribute_sources (product_attribute_id);
 
truncate table dbo.product_mapping_attribute_sources restart identity;
 
 
create table dbo.product_mapping_pass_sources
(
	product_mapping_pass_source_id int generated always as identity primary key,
  product_mapping_id int not null,
  season_pass_type_id int not null,
  season_pass_type_name varchar(50) not null,
	 
	foreign key (product_mapping_id) references dbo.product_mappings(product_mapping_id)
);
 
create index product_mapping_pass_sources_mapping_idx on dbo.product_mapping_pass_sources (product_mapping_id);
create index product_mapping_pass_sources_pass_idx on dbo.product_mapping_pass_sources (season_pass_type_id);
 
truncate table dbo.product_mapping_pass_sources restart identity;
  
 
create table dbo.product_mapping_level_sources
(
	product_mapping_level_source_id int generated always as identity primary key,
  product_mapping_id int not null,
	product_type_id int not null,
  product_type_name varchar(50) not null,
	product_level_id int not null,
	product_level_name varchar(50) not null,
		 
	foreign key (product_mapping_id) references dbo.product_mappings(product_mapping_id)
);
 
create index product_mapping_level_sources_mapping_idx on dbo.product_mapping_level_sources (product_mapping_id);
 
truncate table dbo.product_mapping_level_sources restart identity;
  
 
create table dbo.product_mapping_redemptions
(
	product_mapping_redemption_id int generated always as identity primary key,
  product_mapping_id int not null,
	home_site_id int not null,
  shared_site_id int not null,
	product_id bigint not null,
  product_name varchar(100) not null,
		
	foreign key (product_mapping_id) references dbo.product_mappings(product_mapping_id),
	foreign key (shared_site_id) references dbo.sites(site_id), 
	foreign key (home_site_id) references dbo.sites(site_id) 
);
 
create index product_mapping_redemptions_mapping_idx on dbo.product_mapping_redemptions (product_mapping_id);
create index product_mapping_redemptions_sharsite_idx on dbo.product_mapping_redemptions (shared_site_id);
create index product_mapping_redemptions_homsite_idx on dbo.product_mapping_redemptions (home_site_id);
  
truncate table dbo.product_mapping_redemptions restart identity;
  
 
create table dbo.ticket_activities
(
	ticket_activity_id bigint generated always as identity primary key,
  ticket_id bigint not null,
	activity_date date null,
	activity_time timestamp null,
	product_mapping_id int not null,
  shared_site_id int not null,
  redemption_product_id bigint not null,
	redemption_product_name varchar(50) not null,
		
	foreign key (ticket_id) references dbo.tickets(ticket_id),	
	foreign key (product_mapping_id) references dbo.product_mappings(product_mapping_id),
	foreign key (shared_site_id) references dbo.sites(site_id) 
);
 
create index ticket_activities_homsite_idx on dbo.ticket_activities (ticket_id);
create index ticket_activities_mapping_idx on dbo.ticket_activities (product_mapping_id);
create index ticket_activities_sharsite_idx on dbo.ticket_activities (shared_site_id);
create index ticket_activities_prod_idx on dbo.ticket_activities (redemption_product_id);
  
truncate table dbo.ticket_activities restart identity;
   
 
insert into site_systems(site_system_id, site_system_code, site_system_name)
VALUES
	(1, 'GC', 'GATE CENTRAL'),
	(2, 'SFTS', 'SIX FLAGS');
 
 
insert into mapping_types(mapping_type_code, mapping_type_name)
VALUES
	('PRD', 'PRODUCT'),
	('ATTR', 'PRODUCT ATTRIBUTE'),
	('SP', 'SEASON PASS'),
	('PRDLEV', 'PRODUCT LEVEL');
 
 
insert into sites(site_code, site_name, internal_system_site_id, internal_system_site_code, site_system_id)
VALUES
	('SFOT', 'Six Flags Over Texas', 1, '01', 2),
	('SFOG', 'Six Flags Over Georgia', 2, '02', 2),
	('SFSL', 'Six Flags St. Louis', 3, '03', 2),
	('SFGA', 'Six Flags Great Adventure', 4, '05', 2),
	('SFMM', 'Six Flags Magic Mountain', 5, '06', 2),
	('SFAM', 'Six Flags America', 6, '09', 2),
	('SFGR', 'Six Flags Great America', 7, '10', 2),
	('SFHHLA', 'Six Flags Hurricane Harbor, Los Angeles', 8, '11', 2),
	('SFHHA', 'Six Flags Hurricane Harbor, Arlington', 9, '13', 2),
	('SFFT', 'Six Flags Fiesta Texas', 10, '14', 2),
	('SFWS', 'Six Flags Wild Safari, Jackson', 11, '15', 2),
	('SFWWA', 'Six Flags White Water, Atlanta', 12, '22', 2),
	('SFGEL', 'Six Flags Great Escape Lodge & Waterpark', 13, '23', 2),
	('SFGE', 'The Great Escape', 14, '24', 2),
	('SFHHNJ', 'Six Flags Hurricane Harbor, Jackson', 15, '25', 2),
	('SFNE', 'Six Flags New England', 16, '35', 2),
	('SFDK', 'Six Flags Discovery Kingdom', 17, '36', 2),
	('SFDC', 'Six Flags Corporate Office, Arlington', 19, '51', 2),
	('SFMX', 'Six Flags México', 20, '60', 2),
	('SFMC', 'La Ronde, Montreal', 21, '69', 2),
	('SFHHCH', 'Six Flags Hurricane Harbor, Chicago', 22, '20', 2),
	('SFHHOX', 'Six Flags Hurricane Harbor, Oaxtepec', 23, '59', 2),
	('SFHHCO', 'Six Flags Hurricane Harbor, Concord', 24, '42', 2),
	('SFFC', 'Six Flags Frontier City', 25, '43', 2),
	('SFWWB', 'Six Flags Hurricane Harbor, Oklahoma City', 26, '44', 2),
	('SFDL', 'Six Flags Darien Lake', 27, '45', 2),
	('SFWWP', 'Six Flags Hurricane Harbor, Phoenix', 28, '46', 2),
	('SFWWST', 'Six Flags Over Six Flags Hurricane Harbor, SplashTown', 29, '47', 2),
	('SFMW', 'Six Flags Hurricane Harbor, Rockford', 30, '48', 2),
	 
	('CP', 'Cedar Point', 1, NULL, 1), 
	('KB', 'Knott''s Berry Farm', 4, NULL, 1), 
	('WF', 'Worlds of Fun', 6, NULL, 1), 
	('DP', 'Dorney Park', 8, NULL, 1), 
	('MA', 'Michigan''s Adventure', 12, NULL, 1), 
	('VF', 'Valleyfair', 14, NULL, 1), 
	('KI', 'Kings Island', 20, NULL, 1), 
	('KD', 'Kings Dominion', 25, NULL, 1), 
	('NB', 'Schlitterbahn NB', 26, NULL, 1), 
	('GV', 'Schlitterbahn GV', 27, NULL, 1), 
	('CA', 'Carowinds', 30, NULL, 1), 
	('GA', 'Great America', 35, NULL, 1), 
	('CW', 'Canada''s Wonderland', 40, NULL, 1), 
	('KSC', 'Knott''s Soak City', 201, NULL, 1), 
	('CPS', 'Cedar Point Shores', 202, NULL, 1), 
	('CPR', 'Cedar Point Castaway Bay', 203, NULL, 1);
	 
 
 select * from site_systems;
 select * from mapping_types;
 select * from sites;
 
  