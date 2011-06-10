{*********************************************************}
{                   MasterDetail Report Template                }
{*********************************************************}
{            Copyright (c) 2011 Sri Wahono                }
{*********************************************************}
{ License Agreement:                                      }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the Repaz libraries and packages are }
{ distributed under the Library GNU General Public        }
{ License with the following  modification:               }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library.                          }
{                                                         }
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{                http://www.msegui.org/repaz              }
{                                                         }
{*********************************************************}

type

 TMasterTabs = class(TNormalTabs,idbeditinfo)
  private
   fkeyfieldlink: tfielddatalink;
  protected 
   procedure setdatasource(const avalue: string);override;
   function getkeyfield: string;
   procedure setkeyfield(const avalue: string);   
   //idbeditinfo
   function getdataset(const aindex: integer): tdataset; overload;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);
  public
   constructor create(const aowner: TraReportTemplate);override;
   destructor destroy; override;
   procedure assign(source: TPersistent);override;
  published
   property KeyField: string read getkeyfield write setkeyfield;
 end;

 TDetailTabs = class(TNormalTabs,idbparaminfo)
  private
   fparamname: string;
  protected
   //idbparaminfo
   function getdestdataset: tsqlquery;
  public
   procedure assign(source: TPersistent);override;   
  published
   property Param: string read fparamname write fparamname;
 end;
 
 TraMasterDetailContent = class(toptionalpersistent)
  private
   fheader: TNormalTabs;
   fmaster: TMasterTabs;
   fdata: TDetailTabs;
   ffooter: TSummaryTabs;
   fowner: TraReportTemplate;
   frecordnumber,fmasternumber: integer;
   newheader,newgroup,fmodfooter: boolean;
  public
   constructor create(const aowner: TraReportTemplate); reintroduce; overload;
   destructor destroy; override;
   procedure paint(const canvas: tcanvas;const area:rectty);
   function build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
   procedure adddatasets(var adatasets: datasetarty);
   procedure init;
   procedure updatelinks;
   property masternumber: integer read fmasternumber;
   property recordnumber: integer read frecordnumber;
  published
   property Master: TMasterTabs read fmaster write fmaster;
   property Detail_Header: TNormalTabs read fheader write fheader;
   property Detail_Footer: TSummaryTabs read ffooter write ffooter;
   property Detail_Data: TDetailTabs read fdata write fdata;
 end;   

 TraMasterDetailReport = class(TraReportTemplate)
  private
   fcontent: TraMasterDetailContent;   
  protected
   function getauthor:msestring;override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure drawcontent(const canvas: tcanvas;const contentarea:rectty);override;
   function buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;override;
   procedure addcontentdatasets(var adatasets: datasetarty);override;
   procedure contentinit; override;
   procedure contentupdatelinks; override;
   procedure setcontentpixelperunit(const avalue: real);override;
   function contentheadervalue(indexcol:integer): variant;
   function contentfootervalue(indexcol:integer): variant;
   function contentdatavalue(indexcol:integer): variant;
   function masternumber: integer;override;
   function recordnumber: integer;override;
  published
   property Report_Content: TraMasterDetailContent read fcontent write fcontent;
 end;
