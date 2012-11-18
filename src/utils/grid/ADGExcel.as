package utils.grid
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;

	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
	import mx.utils.ObjectUtil;

	public class ADGExcel
	{
		public function ADGExcel()
		{
		}

		private static var downloadFileRef:FileReference;

		public static function exportToExcel(adg:AdvancedDataGrid, fileNameWithExtension:String):void
		{
			try
			{

				var xlsData:String=new String();
				xlsData=convertADGToHTMLTable(adg);
				if (!downloadFileRef)
				{
					downloadFileRef=new FileReference();
				}

				downloadFileRef.save(xlsData, fileNameWithExtension);
			}
			catch (e:Event)
			{

				Alert.show('Error Occured');

			}
			catch (event:IOErrorEvent)
			{

				Alert.show('IOErrorEvent Occured');

			}

		}

		private static function convertADGToHTMLTable(adg:AdvancedDataGrid):String
		{
			//Set default values
			var str:String='';
			var colors:String='';
			var hcolor:Array;
			hcolor=['green'];

			//Set the htmltabel  
			str+='<table  border=1><thead><tr>';

			//Alert.show(adg.columns.toString());
			var childLength:int=0;
			var skipCnt:int=0;
			//Set the table header data (retrieves information from the datagrid header)				
			for (var i:int=0; i < adg.groupedColumns.length; i++)
			{

				if ((adg.groupedColumns[i] is AdvancedDataGridColumnGroup))
				{
					//Alert.show(ObjectUtil.getClassInfo(adg.columns[i]).toString());
					//	Alert.show(ObjectUtil.toString(adg.columns[i]));
					//	Alert.show(ObjectUtil.toString(adg.groupedColumns[i]));
					childLength=getChildrenLevel(adg.groupedColumns[i] as AdvancedDataGridColumnGroup);
					//	Alert.show(adg.groupedColumns[i].headerText + " is a GC" + String(childLength));

					str+='<th  style="background-color:#D9D9D9" colspan=' + childLength + ' >' + adg.groupedColumns[i].headerText + '</th>';
					skipCnt=skipCnt + childLength - 1;

					childLength=0;


				}
				else
				{

					var temp:int=i + skipCnt;


					//	Alert.show(adg.columns[temp].headerText + ':::'+String(skipCnt) + ':::'+ temp  + ':::'+ i );

					if (adg.columns[i + skipCnt].headerText != undefined)
					{
						str+='<th  style="background-color:#D9D9D9" rowspan=' + 3 + '>' + adg.columns[temp].headerText + '</th>';
					}
					else
					{
						str+='<th  style="background-color:#D9D9D9" rowspan=' + 3 + '>' + adg.columns[temp].dataField + '</th>';
					}

					continue;

				}

			}
			str+="</tr><tr> ";

			childLength=0;
			//Set the table header data (retrieves information from the datagrid header)				
			for (var x:int=0; x < adg.groupedColumns.length; x++)
			{
				if ((adg.groupedColumns[x] is AdvancedDataGridColumnGroup))
				{
					var tempGC:AdvancedDataGridColumnGroup=adg.groupedColumns[x] as AdvancedDataGridColumnGroup;
					for (var n:int=0; n < tempGC.children.length; n++)
					{
						if ((tempGC.children[n] is AdvancedDataGridColumnGroup))
						{

							childLength=getChildrenLevel(tempGC.children[n] as AdvancedDataGridColumnGroup);
							str+='<th  style="background-color:#D9D9D9" colspan=' + childLength + ' >' + tempGC.children[n].headerText + '</th>';
							childLength=0;
						}
						else
						{

							str+='<th  style="background-color:#D9D9D9"></th>';
							continue;
						}
					}




				}
				/**	else
				   {

				   str+='<th  style="background-color:#D9D9D9"></th>';
				   continue;
				 }**/

			}
			str+="</tr><tr> ";


			for (var L1:int=0; L1 < adg.groupedColumns.length; L1++)
			{
				//	Alert.show(String(L1) + ':' + adg.columns[L1].headerText  + ':'+adg.groupedColumns[L1].headerText);
				if (adg.groupedColumns[L1] is AdvancedDataGridColumnGroup)
				{

					var tempL1Cg:AdvancedDataGridColumnGroup=(adg.groupedColumns[L1] as AdvancedDataGridColumnGroup);
					for (var L2:int=0; L2 < tempL1Cg.children.length; L2++)
					{
						if (tempL1Cg.children[L2] is AdvancedDataGridColumnGroup)
						{
							//Alert.show((adg.groupedColumns[L1] as AdvancedDataGridColumnGroup).children[L2].headerText);
							var tempL2Cg:AdvancedDataGridColumnGroup=tempL1Cg.children[L2];
							for (var L3:int=0; L3 < tempL2Cg.children.length; L3++)
							{
								str+='<th  style="background-color:#D9D9D9">' + tempL2Cg.children[L3].headerText + '</th>';

							}


						}
						else
							str+='<th  style="background-color:#D9D9D9">' + tempL1Cg.children[L2].headerText + '</th>';
					}
				}


			}
			str+="</tr></thead><tbody>";
			var color:String;

			//Loop through the records in the dataprovider and 
			//insert the column information into the table

			if(adg.dataProvider == null)
			{
				str+="</tbody></table>";

				return str;

			}
			for (var j:int=0; j < adg.dataProvider.length; j++)
			{

				if (j % 2 == 0)
					color="#F6CCDA";
				else
					color="#AEEEEE";
				str+="<tr>";
				for (var k:int=0; k < adg.columns.length; k++)
				{

					//Do we still have a valid item?						
					if (adg.dataProvider.getItemAt(j) != undefined && adg.dataProvider.getItemAt(j) != null)
					{

						//Check to see if the user specified a labelfunction which we must
						//use instead of the dataField
						if (adg.columns[k].labelFunction != undefined)

						{

							str+="<td style='background-color:" + color + "'>" + adg.columns[k].labelFunction(adg.dataProvider.getItemAt(j), adg.columns[k].dataField) + "</td>";

						}
						else
						{
							//Our dataprovider contains the real data
							//We need the column information (dataField)
							//to specify which key to use.
							str+="<td style='background-color:" + color + "'>" + adg.dataProvider.getItemAt(j)[adg.columns[k].dataField] + "</td>";
						}
					}
				}
				str+="</tr>";
			}
			str+="</tbody></table>";

			return str;
		}

		private static function getChildrenLevel(gc:AdvancedDataGridColumnGroup):int
		{
			var count:int=0;

			for (var t:int=0; t < gc.children.length; t++)
			{
				if (gc.children[t] is AdvancedDataGridColumnGroup)
					count=count + (gc.children[t] as AdvancedDataGridColumnGroup).children.length;
				else
					count=count + 1;
			}


			return count;
		}


	}
}

