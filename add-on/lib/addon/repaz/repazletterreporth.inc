{*********************************************************}
{                   Letter Template                }
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
 TraLetterContent = class(toptionalpersistent)
 private
  fdata: TNormalTabsCol;
  fowner: TraReportTemplate;
  fdatanumber: integer;
  fheight: real;
 public
  constructor create(const aowner: TraReportTemplate); reintroduce; overload;
  destructor destroy; override;
  procedure paint(const canvas: tcanvas;const area:rectty);
  function build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
  procedure adddatasets(var adatasets: datasetarty);
  procedure init;
  procedure updatelinks;
  property datanumber: integer read fdatanumber;
 published
  property HeightContent: real read fheight write fheight;
  property LetterContent: TNormalTabsCol read fdata write fdata;
 end;   

 TraLetterReport = class(TraReportTemplate)
  private
   fcontent: TraLetterContent;   
  protected
   function getauthor:msestring;override;
   function lettervalue(indexrow: integer; indexcol:integer): variant;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure drawcontent(const canvas: tcanvas;const contentarea:rectty);override;
   function buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;override;
   procedure addcontentdatasets(var adatasets: datasetarty);override;
   procedure contentinit; override;
   procedure contentupdatelinks; override;
   procedure setcontentpixelperunit(const avalue: real);override;
  published
   property Page_Header_RowValues;
   property Page_Header_Height;
   property Page_Footer_RowValues;
   property Page_Footer_Height;
   property Report_Header_RowValues;
   property Report_Header_Height;
   property Report_Header_Show;
   property Report_Footer_RowValues;
   property Report_Footer_Height;
   property Report_Footer_Show;
   property Report_Footer_Options;
   property Report_Content: TraLetterContent read fcontent write fcontent;
 end;
