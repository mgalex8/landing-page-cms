<h2><?php echo __('Images') ?></h2>
<div class="row space">
    <div class="span12 ">                
        <a class="btn btn-success" href="<?php echo URL::base(true); ?>admin/images/addedit"><i class="icon-ok icon-white"></i> Add image</a>        
        <a class="btn btn-danger remove-btn"><i class="icon-remove icon-white"></i> Delete selected</a>
    </div>    
</div>
<div class="row space">
    <div class="span12">
        <form id="delete-form" method="POST">
            <table class="table table-striped table-hover" id="user-table">
                <thead>
                    <tr>
                        <th class="span1 text-center"><input type="checkbox" /></th>                        
                        <th class="span1">image</th>
                        <th class="span1">Current</th>                        
                        <th class="span2">Title</th>
                        <th class="span4">File</th>                        
                        <th class="span3">Created</th>
                        <th class="span3">Last time</th>
                        <th class="span5"></th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                        foreach ($images as $img){
                    ?>
                        <tr>
                            <td class="text-center"><input type="checkbox" name="delete[<?php echo $img->id; ?>]" img_id="<?php echo $img->id; ?>" /></td>
                            <td><img src="<?php echo $img->file; ?>" alt="" /></td>
                            <td style="text-align:center"><?php 
                                    if ($img->current) {
                                        echo '<i class="icon-ok icon-black">';
                                    }                                    
                                ?></td>                            
                            <td><?php echo $img->title; ?></td>
                            <td><div class="image-file-url"><a href="<?php echo $img->file; ?>" title="<?php echo $img->file; ?>" target="_blank"><?php echo $img->file; ?></a></div></td>
                            <td><?php 
                                    if (strlen(strval($img->created_time)) == 10) {
                                        echo date("Y-m-d H:i:s", $img->created_time); 
                                    }
                                    else {
                                        echo '-';   
                                    } 
                                ?></td>
                            <td><?php 
                                    if (strlen(strval($img->last_time)) == 10) {
                                        echo date("Y-m-d H:i:s", $img->last_time); 
                                    }
                                    else {
                                        echo '-';   
                                    } 
                                ?></td>
                            <td class="text-center">
                                <a class="btn btn-success" href="<?php echo URL::base(true); ?>admin/images/addedit?id=<?php echo $img->id ;?>">Edit</a>        
                                <a class="btn btn-danger remove-image-btn" img_id="<?php echo $img->id ;?>">Delete</a>
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
            var img_id = jQuery(this).attr('img_id');
            var cbox = jQuery('input[img_id='+img_id+']');
            cbox.prop('checked',true);
            jQuery('#delete-form').submit();
        });
        
    });
</script>