<h2><?php echo __('Quotes') ?></h2>
<div class="row space">
    <div class="span4" style="width:255px">                
        <a class="btn btn-success" href="<?php echo URL::base(true); ?>admin/quotes/addedit"><i class="icon-ok icon-white"></i> Add qoute</a>        
        <a class="btn btn-danger remove-btn"><i class="icon-remove icon-white"></i> Delete selected</a>
    </div>
    <div class="span2 margin-left4">
        <div class="fileform">   
            <form id="import-form" action="/admin/quotes/import" method="POST" enctype="multipart/form-data">
                <div class="btn btn-default">Import CSV</div>
                <input id="upload" type="file" name="upload" />
            </form>
        </div>
    </div>
    <div class="span6 align-right margin-left31">     
        <div class="search-group">
            <form id="search-form" action="/admin/quotes/search" method="GET">
                <input type="text" class="form-control" placeholder="" name="q" value="<?php echo $search; ?>" />
                <div class="search-group-btn">
                    <input class="btn btn-default" type="submit" value="Search" />
                </div>
        </div>
    </div>
</div>
<div class="row space">
    <div class="span12">
        <form id="delete-form" method="POST">
            <table class="table table-striped table-hover" id="user-table">
                <thead>
                    <tr>
                        <th class="span1 text-center"><input type="checkbox" /></th>                        
                        <th class="span1">Current</th>
                        <th class="span6">Text</th>
                        <th class="span2">Author</th>
                        <th class="span3">Last time</th>
                        <th class="span3"></th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                        foreach ($quotes as $quote){
                    ?>
                        <tr>
                            <td class="text-center"><input type="checkbox" name="delete[<?php echo $quote->id; ?>]" data-id="<?php echo $quote->id; ?>" /></td>                            
                            <td style="text-align:center"><?php 
                                    if ($quote->current) {
                                        echo '<i class="icon-ok icon-black">';
                                    }
                                ?></td>                           
                            <td><?php 
                                    $text = $quote->text;
                                    if ($search)
                                    {
                                        $replace = '<b>'.$search.'</b>';
                                        $text = str_replace($search, $replace, $text);                                    
                                    }
                                    echo $text;                                    
                                ?></td>                            
                            <td><?php 
                                    $author = $quote->author; 
                                    if ($search)
                                    {
                                        $replace = '<b>'.$search.'</b>';
                                        $author = str_replace($search, $replace, $author);                                    
                                    }
                                    echo $author;
                                ?></td>
                            <td><?php 
                                    if (strlen(strval($quote->last_time)) == 10) {
                                        echo date("Y-m-d H:i:s", $quote->last_time);
                                    }
                                    else {
                                        echo '-';
                                    }
                                ?></td>
                            <td class="text-center">
                                <a class="btn btn-success" href="<?php echo URL::base(true); ?>admin/quotes/addedit?id=<?php echo $quote->id ;?>">Edit</a>
                                <a class="btn btn-danger remove-image-btn" data-id="<?php echo $quote->id ;?>">Delete</a>
                            </td>
                        </tr>
                    <?php
                    }
                    ?>
                </tbody>
            </table>
        </form>
    </div>
</div>

<?php echo $pagination; ?>

<br/>

<?php if (isset($messages['delete'])) { ?>
    <div class="alert alert-success"><?php echo $messages['delete'] ?></div>
<?php } ?>
<script>
    jQuery(document).ready(function(){
        jQuery('.selectpicker').selectpicker();
                        
        var checkboxes = jQuery('td input[type=checkbox]'),
            disabling = function(){
                if (checkboxes.filter(':checked').length === 0){
                    jQuery('.remove-btn').addClass('disabled');
                    jQuery('.block-btn').addClass('disabled');
                    jQuery('.activate-btn').addClass('disabled');
                }
                else {
                    jQuery('.remove-btn').removeClass('disabled');
                    jQuery('.block-btn').removeClass('disabled');
                    jQuery('.activate-btn').removeClass('disabled');
                }                
            };
        jQuery('td input[type=checkbox]').on('change',function(){
            console.log(this);
            disabling();
        });
        
        jQuery(function(){
            jQuery('th input[type=checkbox]').on('change',function(){
                if (jQuery(this).is(':checked')){
                    jQuery('td input[type=checkbox]').prop('checked',true);
                }
                else{
                    jQuery('td input[type=checkbox]').prop('checked',false);
                }
                disabling();
            });
        });
        disabling();        
        
        jQuery('.remove-btn').on('click', function(){
            if ( !jQuery(this).is('.disabled')) {
                jQuery('#delete-form').submit();
            }
        });
        
        jQuery('.remove-image-btn').on('click', function(){
            var img_id = jQuery(this).attr('data-id');
            var cbox = jQuery('input[data-id='+img_id+']');
            cbox.prop('checked',true);
            jQuery('#delete-form').submit();
        });
        
    });
    
    jQuery('#upload').on('change', function(){       
       jQuery('#import-form').submit();
    });
    
    
</script>